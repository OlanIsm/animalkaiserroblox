# Animal Kaiser Roblox — persistent project specification

## Development rules
- Git is the source of truth for gameplay code. Edit all Rojo-managed Luau through local repository files, never through Studio MCP.
- Use Studio MCP to inspect the DataModel/Workspace, create and configure non-code instances and simple geometry, search/insert Creator Store assets, playtest, debug runtime errors, and validate gameplay.
- Keep the game and map simple. Prefer Parts over complex assets. Inspect every inserted model and remove unnecessary or suspicious scripts. No large asset packs.
- The server owns Strength, Cash, rewards, damage, block HP, inventory, purchases, glove ownership/equip, Punch Area, selling, and rebirth. Validate client actions and never accept client-supplied values for these.
- No DataStore in the first pass. Progress is session-only.

## Game loop
Shadowbox → gain Strength → punch individual wall blocks → discover and collect Brainrots → sell for Cash → buy stronger gloves → train faster → upgrade Punch Area → reach harder zones → rebirth for permanent Cash and training speed bonuses.

## Player progression
- Leaderstats: Strength, Cash, Rebirths.
- Server-side progression: equipped glove, owned gloves, Punch Area Level, Brainrot inventory by type and quantity.
- Two tools: **Shadowboxing** automatically grants Strength per punch while equipped, based on glove; Rebirths increase punch speed with a reasonable cap. Stop on unequip. **Punch** damages individual targeted blocks on a short cooldown; damage mainly follows Strength. Punch Area increases nearby block coverage, not raw damage.

## Initial balance (configurable)
| Glove | Cost | Strength/punch |
| --- | ---: | ---: |
| Bare Hands | 0 | 1 |
| Basic Gloves | 250 | 2 |
| Iron Gloves | 1,500 | 5 |
| Golden Gloves | 10,000 | 10 |

| Punch Area | Cost | Coverage |
| --- | ---: | --- |
| 1 | 0 | target only |
| 2 | 1,000 | small radius |
| 3 | 5,000 | medium radius |
| 4 | 20,000 | larger reasonable radius |

Punch Area radii are 0 / 6.5 / 10 / 14 studs, matched to the 6-stud block spacing.

- Brainrot reward roll per destroyed block: Nothing 55%, Common 30%, Uncommon 12%, Rare 3%. Use 4–6 types, each with Name, Rarity, SellValue. A visual reveal and simple found/value feedback are desirable; placeholder models are fine.
- Blocks stay destroyed during an excursion and refresh when their destroyer re-enters the lobby, respawns, or leaves. Restore HP/visuals/collision; defer occupied blocks until players move clear. No automatic 20-second respawn. Block state remains shared and other players' destroyed blocks are not reset by this player's return.
- Rebirth currently requires 100,000 Cash (latest working assumption from the user's cash-progress example). Reset Strength, Cash, purchased gloves, Punch Area; keep Brainrot inventory and Rebirth count. Cash multiplier = `1 + Rebirths * 0.25`; shadowboxing gets a small capped speed bonus. No Rebirth Strength multiplier.

## World and interactions
- Preserve the user's walled central lobby with Spawn and Training Area. Red stall sells, Blue stall is Glove Shop, Green stall is Punch Area Upgrade, Orange stall is reserved and has no action. Rebirth is accessed through HUD.
- Outside the lobby walls: a dense field of individual blocks surrounding the lobby in three increasingly hard zones. Current field is 1,656 blocks in three vertical layers; use the north exit to mine outward. Each block has independent HP, destruction, reward, and reset.
- Zone 1 uses low HP/simple material; Zone 2 medium HP/stone; Zone 3 high HP/dark stone or metal.
- Sell booth sells all carried Brainrots, applies the Rebirth Cash multiplier, clears sold inventory, and shows quantity/Cash feedback.
- Glove Shop buys and equips owned gloves with simple UI. Punch Area booth purchases the next level. Rebirth booth performs validated rebirth.
- HUD shows at least carried Brainrot total and simple feedback. Keep inventory UI lightweight.
- Left HUD order: red Strength pill, green Money pill, purple Brainrots pill. Each stat is informational, with image left and value right. No Punch panel or tap-to-train actions. Below Brainrots, a Rebirth image button shows readiness percentage beneath its icon; opens a progress dialog with Cash needed, pill progress bar, current/required amount, reset/bonus details, and server-validated Rebirth action.
- Each server-awarded Shadowboxing punch shows a floating +Strength popup at a random screen position near the character. Use the actual awarded amount, float upward, fade, and clean up.

## Implementation scope and order
1. Inspect repository and Studio; create this file.
2. Add config, player stats, Shadowboxing, Punch tool, independent breakable blocks, Brainrot rolls/inventory, Sell, Glove Shop, Punch Area, Rebirth.
3. Build a small hub and three block zones; add minimal HUD/feedback.
4. Playtest in Studio, inspect console errors, fix issues, verify the full loop: join/tools → train → damage and individually break Zone 1 blocks → find/carry/sell Brainrots → buy glove and train faster → upgrade area and hit nearby blocks → reach later zones → rebirth and receive bonuses.

## Architecture guidance
Keep modular but simple. Suggested `src/shared/Config` modules: Gloves, Blocks, Brainrots, Upgrades, Rebirth. Suggested `src/server/Services`: PlayerData, Training, Block, Brainrot, Shop, Sell, Upgrade, Rebirth. Suggested `src/client/Controllers`: HUD, Feedback. Adjust structure to the existing project if simpler; avoid needless abstraction.

## Completion report
Summarize systems, files, Studio objects, Creator Store assets, balance values, limitations, placeholders, and decisions that differ from this specification.
