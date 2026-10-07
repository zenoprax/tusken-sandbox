**`tusken-sandbox`** is agentic isolation using Podman to turn `$PWD` into a safer space.

Coding agents are non-deterministic general-purpose programs and therefore cannot be trusted. My approach is a slim image driven by a "just enough permission" `podman run` command. 

Only Opencode is configured at the moment. I just invoke `oc` as a `fish` abbreviation and whatever directory I'm in becomes `/workspace` with no writable access to anything else on the host system.

`$HOME` is set to `.opencode/home` within the project directory.

Set your API key with `podman secret`. For example, with OpenRouter:
`printf '%s' "$YOUR_API_KEY_HERE" | podman secret create openrouter_api_key -`

The `fish` function example shows how it is used for `podman run`.

---


## **tusken**?

As in *Tusken raiders* [^tusken]. Tatooine is a big sandbox and they are free to do what they like there!

<p align="center">
  <img src="https://camo.githubusercontent.com/3d9c1aee0ebf395ca6fde6da001042f2feab6f2ebf5508d7ed0571f023ccee52/68747470733a2f2f7374617469632e77696b69612e6e6f636f6f6b69652e6e65742f73746172776172732f696d616765732f662f66642f5475736b656e732d323031354461727468566164657232352e706e672f7265766973696f6e2f6c61746573742f7363616c652d746f2d77696474682d646f776e2f313030303f63623d3230313631303133303233313034" width="500">
</p>

Rather than contain them in more austere environments such as `firejail` where the exchange rate of utility for security is suboptimal I have instead chosen an environment more similar to LLM training data. This is justified on the basis that they are more *negligent* than *malicious* and that I will not be letting an agent run unattended for hours on end (like the AI labs do) which influences the threat model significantly.

There are many agentic jails but this one is mine. Other solutions I investigated were either doing:
- **too much** making it too easy to accidentally expose something.
- **too little** such as Docker with `cap-add=CAP_SYS_ADMIN` or fully privileged!

[^tusken]: Image sourced from [starwars.fandom.com](https://starwars.fandom.com/wiki/Tusken_Raider).
