## Öncelikle Cloudflare One Client programında Yerel Proxy modunu aktif ettiğinizden emin olun.
<img width="554" height="425" alt="image" src="https://github.com/user-attachments/assets/9a96339c-4916-4c6e-8e7c-e94c4464fde2" />


Scripti indirin ve çalıştırın. Discord'u WARP'ın proxy adresine bağlamak için gerekli ayarlamaları yapan bir VBS dosyası oluşturur ve bu VBS'nin kısayolunu masaüstüne Discord (WARP) ismiyle atar. Artık sadece bu kısayolu tıklayarak Discord'u WARP üzerinden açabilirsiniz.

## Neden ekstra olarak sing-box kullandım?

WARP'ın Proxy tüneline (socks5://127.0.0.1:40000) Discord'u direkt olarak sokabilirdik ancak bu tünelden DNS çözümlemesi yapılmıyor.
Sisteminizde özel DNS kullanıyorsanız bu bir problem olmazdı ancak kullanıcının DNS'inin zehirlenmiş olma ihtimalini tamamen ortadan kaldırmak en iyisidir diye düşündüm.
Bu nedenle Sing-box'u WARP tüneline (socks5://127.0.0.1:40000) bağlanıp, bir DNS çözümleyici ekleyip tekrar kendi tünelini (socks5://127.0.0.1:40001) oluşturacak şekilde yapılandırdım.
Böylece discord'un DNS çözümlemeleri de bu tünelden yapılacak ve WARP tüneline iletilecek. Sisteminizde ayrıca DNS değiştirmenize gerek kalmayacak.

**Sing-box proje sayfası:** https://github.com/sagernet/sing-box

## version.dll nedir?

Bu dll dosyası Discord'un özel proxy adresleriyle açılmasını sağlayan bir dosyadır. Update.exe -a --proxy-server=(proxy-adresi) şeklinde çalıştırmanıza izin verir.
**Ayrıntılı bilgi:** https://github.com/aiqinxuancai/discord-proxy/
