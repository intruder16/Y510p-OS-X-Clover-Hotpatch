// Created by : Intruder16
// Credits : RehabMan

// Add the missing MCHC device

DefinitionBlock("", "SSDT", 2, "Y510p", "MCHC", 0)
{
    External(_SB.PCI0, DeviceObj)

    Scope(_SB.PCI0)
    {
        Device (MCHC)
        {
            Name (_ADR, Zero)  // _ADR: Address
        }
    }
}
//EOF
