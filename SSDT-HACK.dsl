// Creating one All-In-One SSDT for hacks, no need to use SortedOrder
// There are of course seperate SSDT's in "seperate" folder NOTE : Use SortedOrder with this.

// Created by : Intruder-16
// Credits : RehabMan

DefinitionBlock ("", "SSDT", 2, "hack", "hack", 0)
{
    External(_SB.PCI0, DeviceObj)
    External(_SB.PCI0.LPCB, DeviceObj)

    // All _OSI calls in DSDT are routed to XOSI...
    // XOSI simulates "Windows 2012" (which is Windows 8)
    // Note: According to ACPI spec, _OSI("Windows") must also return true
    // Also, it should return true for all previous versions of Windows.
    Method(XOSI, 1)
    {
        Store(Package()
        {
            "Windows",              // generic Windows query
            "Windows 2001",         // Windows XP
            "Windows 2001 SP2",     // Windows XP SP2
            //"Windows 2001.1",     // Windows Server 2003
            //"Windows 2001.1 SP1", // Windows Server 2003 SP1
            "Windows 2006",         // Windows Vista
            "Windows 2006 SP1",     // Windows Vista SP1
            //"Windows 2006.1",     // Windows Server 2008
            "Windows 2009",         // Windows 7/Windows Server 2008 R2
            "Windows 2012",         // Windows 8/Windows Server 2012
            //"Windows 2013",       // Windows 8.1/Windows Server 2012 R2
            //"Windows 2015",       // Windows 10/Windows Server TP
        }, Local0)
        Return (Ones != Match(Local0, MEQ, Arg0, MTR, 0, 0))
    }

//
// USB related
//
    // For solving instant wake by hooking GPRW
    
    Method(GPRW, 2)
    {
        If (0x6d == Arg0) { Return (Package() { 0x6d, Zero, }) }
        If (0x0d == Arg0) { Return (Package() { 0x0d, Zero, }) }
        External(\XPRW, MethodObj)
        Return (XPRW(Arg0, Arg1))
    }
        
    // Inject properties for EC01
    
    External(_SB.PCI0.EH01, DeviceObj)
    
    If (CondRefOf(_SB.PCI0.EH01))
    {
        Method(_SB.PCI0.EH01._DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "subsystem-id", Buffer() { 0x70, 0x72, 0x00, 0x00 },
                "subsystem-vendor-id", Buffer() { 0x86, 0x80, 0x00, 0x00 },
                "AAPL,current-available", Buffer() { 0x34, 0x08, 0, 0 },
                "AAPL,current-extra", Buffer() { 0x98, 0x08, 0, 0, },
                "AAPL,current-extra-in-sleep", Buffer() { 0x40, 0x06, 0, 0, },
                "AAPL,max-port-current-in-sleep", Buffer() { 0x34, 0x08, 0, 0 },
            })
        }
    }
    
    // Inject properties for EH02
    
    External(_SB.PCI0.EH02, DeviceObj)
    
    If (CondRefOf(_SB.PCI0.EH02))
    {
        Method(_SB.PCI0.EH02._DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "subsystem-id", Buffer() { 0x70, 0x72, 0x00, 0x00 },
                "subsystem-vendor-id", Buffer() { 0x86, 0x80, 0x00, 0x00 },
                "AAPL,current-available", Buffer() { 0x34, 0x08, 0, 0 },
                "AAPL,current-extra", Buffer() { 0x98, 0x08, 0, 0, },
                "AAPL,current-extra-in-sleep", Buffer() { 0x40, 0x06, 0, 0, },
                "AAPL,max-port-current-in-sleep", Buffer() { 0x34, 0x08, 0, 0 },
            })
        }
    }
    
    // Inject properties for XHC
    
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

//
// Backlight control
//
    Device (_SB.PCI0.IGPU.PNLF)
    {
        Name(_ADR, Zero)
        Name(_HID, EisaId ("APP0002"))
        Name(_CID, "backlight")
        Name(_UID, 10)
        Name(_STA, 0x0B)
        Name(RMCF, Package()
        {
            "PWMMax", 0,
        })
        Method(_INI)
        {
            // Disable discrete graphics (Nvidia) if it is present
            
            External(\_SB.PCI0.PEG0.PEGP._OFF, MethodObj)
            If (CondRefOf(\_SB.PCI0.PEG0.PEGP._OFF))
            {
                \_SB.PCI0.PEG0.PEGP._OFF()
            }
        }
    }
    
    // Brightness Keys Fix
    
    Device (RMKB)
    {
        Name (_HID, "RMKB0000")
    }
    
    External(_SB.PCI0.LPCB.EC0, DeviceObj)

    Scope (_SB.PCI0.LPCB.EC0)
    {
        Method (_Q11, 0, NotSerialized)
        {
            Notify (RMKB, 0x114F)
            Notify (RMKB, 0x124F)
        }

        Method (_Q12, 0, NotSerialized)
        {
            Notify (RMKB, 0x114D)
            Notify (RMKB, 0x124D)
        }
    }
    
//
// Standard Additions/Injections/Fixes
//

    Scope(_SB.PCI0)
    {
        // Add the missing IMEI device
        
        Device(IMEI)
        {
            Name (_ADR, 0x00160000)
        }
        
        // Add the missing MCHC device
        
        Device (MCHC)
        {
            Name (_ADR, Zero)
        }
        
        // Add SMBBUS Device

        Device(SBUS.BUS0)
        {
            Name(_CID, "smbus")
            Name(_ADR, Zero)
            Device(DVL0)
            {
                Name(_ADR, 0x57)
                Name(_CID, "diagsvault")
                Method(_DSM, 4)
                {
                    If (!Arg2) { Return (Buffer() { 0x03 } ) }
                    Return (Package() { "address", 0x57 })
                }
            }
        }
    }
    
    // Automatic injection of IGPU properties

    External(_SB.PCI0.IGPU, DeviceObj)

    Scope(_SB.PCI0.IGPU)
    {
        Method (_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Return (Package ()
            {
                "device-id", Buffer () { 0x12, 0x04, 0x00, 0x00 }, 
                "AAPL,ig-platform-id", Buffer () { 0x06, 0x00, 0x26, 0x0A }, 
                "hda-gfx", Buffer () { "onboard-1" }, 
                "AAPL00,DualLink", Buffer () { 0x01, 0x00, 0x00, 0x00 }, 
                "model", Buffer () { "Intel HD 4600" },
            })
        }
    }

    // Automatic injection of HDAU properties
    
    External(_SB.PCI0.HDAU, DeviceObj)
    
    Method(_SB.PCI0.HDAU._DSM, 4)
    {
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Return (Package ()
        {
            "layout-id", Buffer() { 3, 0, 0, 0 },
            "hda-gfx", Buffer() { "onboard-1" },
        })
    }
    
    // Fix _WAK
    
    External (ZWAK, MethodObj)
    
    Method (_WAK, 1, NotSerialized)
    {
        If (LOr (LLess (Arg0, One), LGreater (Arg0, 0x05)))
        {
            Store (0x03, Arg0)
        }

        Store (ZWAK (Arg0), Local0)
        Return (Local0)
    }
    
    // Fix unsupported 8-series LPC devices
    
    External(_SB.PCI0.LPCB, DeviceObj)

    Scope(_SB.PCI0.LPCB)
    {
        Method (_DSM, 4, NotSerialized)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Return (Package () { "compatible", "pci8086,9c43" })
        }
    }
    
//
// Battery Status
//

    // Override for ACPIBatteryManager.kext
    
    External(_SB.BAT1, DeviceObj)
    Name(_SB.BAT1.RMCF, Package()
    {
        "StartupDelay", 10,
    })

    External (_SB.PCI0.LPCB.ECOK, MethodObj)
    External (_SB.PCI0.LPCB.EC0.ENDD, FieldUnitObj)
    External (_TZ.THLD, UnknownObj)
    External (_TZ.TZ00.PTMP, UnknownObj)
    
    Scope (_TZ)
    {
        Method (_TMP, 0, Serialized)
        {
            If (\_SB.PCI0.LPCB.ECOK ())
            {
                Store (Zero, \_SB.PCI0.LPCB.EC0.ENI0)
                Store (0x84, \_SB.PCI0.LPCB.EC0.ENI1)
                Store (\_SB.PCI0.LPCB.EC0.ENDD, Local0)
            }
            Else
            {
                Store (\_TZ.TZ00.PTMP, Local0)
            }

            If (LGreaterEqual (Local0, THLD))
            {
                Return (\_TZ.TZ00.PTMP)
            }
            Else
            {
                Add (0x0AAC, Multiply (Local0, 0x0A), Local0)
                Store (Local0, \_TZ.TZ00.PTMP)
                Return (Local0)
            }
        }
    }
    
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External (FAMX, MutexObj)
    External (ERBD, FieldUnitObj)
    
    Scope (_SB.PCI0.LPCB.EC0)
    {
        OperationRegion (AMER, EmbeddedControl, Zero, 0xFF)
        Field (AMER, ByteAcc, Lock, Preserve)
        {
            Offset (0x5A), 
            Offset (0x5B), 
            Offset (0x5C), 
            Offset (0x5D), 
            ENI0,   8, 
            ENI1,   8
        }
        
        OperationRegion (RMEC, EmbeddedControl, Zero, 0xFF)
        Field (RMEC, ByteAcc, Lock, Preserve)
        {
            Offset (0x5D), 
            ERI0,   8, 
            ERI1,   8
        }

        Method (FANG, 1, NotSerialized)
        {
            Acquire (FAMX, 0xFFFF)
            Store (Arg0, ERI0)
            Store (ShiftRight (Arg0, 0x08), ERI1)
            Store (ERBD, Local0)
            Release (FAMX)
            Return (Local0)
        }

        Method (FANW, 2, NotSerialized)
        {
            Acquire (FAMX, 0xFFFF)
            Store (Arg0, ERI0)
            Store (ShiftRight (Arg0, 0x08), ERI1)
            Store (Arg1, ERBD)
            Release (FAMX)
            Return (Arg1)
        }
    }
}
//EOF
