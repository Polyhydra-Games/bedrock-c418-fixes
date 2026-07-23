# Third-party names, content, and asset boundary

## No bundled audio or game content

This repository and its release artifact must not contain C418 recordings,
derived audio, Minecraft game files, or other unapproved copyrighted content.
The packaging and validation commands reject tracked audio payloads and nested
archives. A successful package check is not a grant of distribution rights.

## Names and trademarks

Minecraft, Bedrock, Mojang, Microsoft, and C418 are used only as descriptive
references where appropriate. Polyhydra Games and this repository are not
affiliated with, endorsed by, sponsored by, or approved by Mojang Studios,
Microsoft, or C418. No license in this repository grants rights in those names,
marks, game content, or music.

## Asset inventory and provenance decision

| Distributed path | Rights basis | Public-release decision |
| --- | --- | --- |
| `mod/manifest.json` | Original repository metadata; covered by `LICENSE` only to the extent owned by Polyhydra Games contributors. | May ship after normal review. The description makes no audio-replacement claim. |
| `mod/pack_icon.png` | **Unverified.** Git history shows it was added in the initial commit by the repository author, but commit attribution alone is not proof of copyright ownership or an authorized license. | **Blocks public release.** The rights owner must record original creation or a suitable distribution license, or replace the icon with a verified owned asset. |
| C418/Minecraft/Mojang/Microsoft names and referenced concepts | Third-party descriptive names only. | Never treated as licensed content or endorsement. |

The 0BSD `LICENSE` intentionally excludes every item whose ownership is not
established. Before a public release, update this table with the icon's actual
rights basis and review the final archive inventory against it.
