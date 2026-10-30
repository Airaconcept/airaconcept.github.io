U=https://speed.cloudflare.com
D="stores.staples.com www.sage.com openai.com guide.for.edu.sg www.giannidelprete.it www.akasantech.com staticdelivery.nexusmods.com www.leics.police.uk www.dbs.com.sg www.blibli.com www.hypixel.net www.speedtest.net www.trumpinternationalrealty.com www.udacity.com www.carousell.sg m.iyf.tv www.sloomb.com chrono24.com store.ubi.com www.shopify.com www.okta.com www.visa.cn"
[ -n "$1" ] && D="$*"
curl -s -o up.bin "$U/__down?bytes=10000000"
: > r.txt
echo "下载Mbps 上传Mbps 延迟ms 域名"
for d in $D; do
  p=$(curl -s -m 5 --connect-to ::$d:443 -w '%{time_starttransfer}\n' -o /dev/null -o /dev/null -o /dev/null "$U/__down?bytes=0" "$U/__down?bytes=0" "$U/__down?bytes=0" | sort -n | head -n 1)
  dl=$(curl -s -o /dev/null -m 10 --connect-to ::$d:443 -w '%{speed_download}' "$U/__down?bytes=25000000")
  ul=$(curl -s -o /dev/null -m 10 --connect-to ::$d:443 -w '%{speed_upload}' --data-binary @up.bin "$U/__up")
  echo "$p $dl $ul $d" | awk '{printf "%7.1f %7.1f %6.0f  %s\n",$2*8/1e6,$3*8/1e6,$1*1000,$4}' >> r.txt
  tail -n 1 r.txt
done
echo "===== 按下载排名 ====="
sort -rn r.txt
