// Created by : Intruder16
// Credits : RehabMan

// Automatic injection of XHC properties

DefinitionBlock("", "SSDT", 2, "Y510p", "XHC", 0)
{
    External(_SB.PCI0.XHC, DeviceObj)
    
    If (CondRefOf(_SB.PCI0.XHC))
    {
        Method(_SB.PCI0.XHC._DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Local0 = Package()
            {
                "RM,pr2-force", Buffer() { 0, 0, 0, 0 },
                "subsystem-id", Buffer() { 0x70, 0x72, 0x00, 0x00 },
                "subsystem-vendor-id", Buffer() { 0x86, 0x80, 0x00, 0x00 },
                "AAPL,current-available", Buffer() { 0x34, 0x08, 0, 0 },
                "AAPL,current-extra", Buffer() { 0x98, 0x08, 0, 0, },
                "AAPL,current-extra-in-sleep", Buffer() { 0x40, 0x06, 0, 0, },
                "AAPL,max-port-current-in-sleep", Buffer() { 0x34, 0x08, 0, 0 },
            }
            // Force USB2 on XHC if EHCI is disabled
            
            If (CondRefOf(\_SB.PCI0.RMD2))
            {
                CreateDWordField(DerefOf(Local0[1]), Zero, PR2F)
                PR2F = 0x3fff
            }
            Return(Local0)
        }
    }
}
//EOF
