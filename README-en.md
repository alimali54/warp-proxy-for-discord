\## First, make sure you have enabled the Local Proxy mode in the Cloudflare One Client.



<img width="554" height="425" alt="image" src="https://github.com/user-attachments/assets/9a96339c-4916-4c6e-8e7c-e94c4464fde2" />



Download and run the script. It creates a VBS file that makes the necessary configurations to connect Discord to WARP's proxy address, and creates a shortcut for this VBS on your desktop named \*\*Discord (WARP)\*\*. From now on, you can launch Discord through WARP simply by clicking this shortcut.



\## Why did I use sing-box as an extra step?



We could have routed Discord directly into WARP's proxy tunnel (`socks5://127.0.0.1:40000`), but this tunnel does not perform DNS resolution. 



If you were using a custom DNS on your system, this wouldn't be an issue. However, I thought it was best to completely eliminate the risk of the user's DNS being poisoned/hijacked. 

Because of this, I configured sing-box to connect to the WARP tunnel (`socks5://127.0.0.1:40000`), add a DNS resolver, and then create its own tunnel (`socks5://127.0.0.1:40001`). 



This way, Discord's DNS queries are also resolved through this tunnel and forwarded to the WARP tunnel. You won't need to change your system DNS settings separately.



\*\*Sing-box project page:\*\* https://github.com/sagernet/sing-box



\## What is version.dll?



This DLL file is what allows Discord to be launched with custom proxy addresses. It enables you to run Discord using the `Update.exe -a --proxy-server=(proxy-address)` argument.



\*\*More details:\*\* https://github.com/aiqinxuancai/discord-proxy/

