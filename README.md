# Clover Hotpatch for Y510p

This repository contains necessary DSDT/SSDT patches used for hotpatching with clover for Y510p.

# Instructions on how to use:

```javascript
1. Clone the repository and use MaciASL to compile SSDT-HACK.dsl & SSDT.dsl
2. The resulting files i.e. SSDT-HACK.aml & SSDT.aml should be placed inside EFI/EFI/CLOVER/ACPI/patched/ folder
Note: Remove any other aml files inside “patched” folder.
3. Copy DSDT “Fixes” & “Patches” from “config.plist” to your config.plist file in EFI/EFI/CLOVER/ folder.
```
There’s also a separate folder containing individual patches for educational purpose only. You can however use them the same as SSDT-HACK.dsl but not together. To use: compile all of them and paste into ACPI/patched. 

If you use individual files from “seperate” folder, make sure you use SortedOrder function in clover’s config.plist to ensure injection in proper order.

Note 1: Remember to compile them in “aml” format before pasting in ACPI/patched

Note 2: You should either use SSDT-HACK.aml & SSDT.aml
			Or
	SSDT’s from separate folder with SSDT.aml.

#Credits:

Rehabman: https://www.tonymacx86.com/threads/guide-using-clover-to-hotpatch-acpi.200137/

