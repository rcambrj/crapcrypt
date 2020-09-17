# crapcrypt

Want to send someone some *mildly sensitive* documents but don't have a secure channel? `crapcrypt` to the rescue!

* takes a directory full of PDFs
* puts a watermark on them
* generates a random password
* uploads the password to [OTS](https://onetimesecret.com)
* creates a password-protected archive of the files
* outputs the OTS link and the file

Now you can email the OTS link and the file to your recipient. I recommend you send the OTS link first and confirm receipt via another channel (eg. telephone call) before sending the password-protected archive.

The watermark will help you determine who leaked your documents, in case that happens some day.

If your filenames are sensitive, [don't use ZIP](https://security.stackexchange.com/questions/35818/are-password-protected-zip-files-secure).

All this said, this isn't supposed to be exhaustively secure. I built it because inexperienced people with whom I deal, usually don't know what GPG is. So here's a thing which puts my mind at rest for a short while. If you want to send me something secure, use [something actually secure instead](https://keys.openpgp.org/vks/v1/by-fingerprint/C8872120B641DC51234831BF920BA69184F6C143).

# Installation

Requires `unzip`, `openssl`, `curl`, `jq`, `imagemagick`, `pdftk-java`. Install these with your favourite package manager.

```brew install unzip openssl curl jq imagemagick pdftk-java```

Optionally:
```brew cask install rar```

# Usage

* copy `example.config.sh` to `config.sh` and put some sensible values in there
* put your PDFs (and any other documents) in `./files`
* run `./pack.sh -w 'Dodgy Client Inc.'`
* you should have a file in `./output`

## Options
* `-r` create a RAR instead of a ZIP
* `-p password` set the password (default: generate randomly)
* `-f size` adjust font size

# Known issues

* should probably ask for `-p` password with a prompt
* will only watermark PDF files
* will only watermark those in the root
* probably breaks with subdirectories in the root