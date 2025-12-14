# Super-Supernote
This is a collection of tools, scripts, and guides to make Supernote devices even more super.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/J3J6BINRX)

## Tips and Tricks

[How to Create a Home Page](tips-and-tricks/how-to-create-a-home-page.md)

Supernote devices are notorious for not having a "home button" but that doesn't meant you can't create your own home page.

## Good to Know

**Wi-Fi** on Supernote devices does not support WPA3. If you can't connect to a WiFi access point, check if it is using WPA3. This is a serious security concern and Ratta should address this.

**PDF Templates** cannot be assigned to a note when creating the note file. However, you can create the note file and then change the template it is using to a PDF template.

## Tools

[supernote-tool](https://github.com/jya-dev/supernote-tool) (Python)

An unofficial python tool for Ratta Supernote. It allows converting a Supernote's *.note file into PNG image file without operating export function on a real device.

[PySN](https://gitlab.com/mmujynya/pysn-digest) (Python)

PySN builds on supernote-tool and provides additional functionality like OCR and LLM processing of hand-written notes. Documentation is scant.

[supernote-typescript](https://github.com/philips/supernote-typescript) (TypeScript)

Heavily inspired on supernote-tool and provides similar functionality

## Templates

[Supernote official documentation](https://support.supernote.com/en_US/faq/how-to-create-a-custom-note-template) on how to create a note template.

[eInk Template Gen](https://github.com/calebc42/eink-template-gen)

A device-agnostic command-line tool for generating mathematically balanced, pixel-perfect page templates for e-ink devices. Developed with the Supernote Manta, this tool supports millimeter or pixel specifications for human-readable, technically-precise, or true-scale template configurations.

Use this tool to create templates for any eInk device.

## Private Cloud

Ratta offers free cloud service to sync notes between Supernote devices and partner apps. They also offer a Private Cloud Docker image so you can self-host a cloud sync service for Supernote devices.

Here is a guide I put together on how to get it up and running.

> [!NOTE]
> This guide assumes you are already running a Linux server and that you have some technical knowledge (or the patience) to troubleshoot a web application.
> Everyone's setup is different and this guide might not work for everyone.

[Supernote Private Cloud Helper Guide](private-cloud/README.md)