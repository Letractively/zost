object DataModule_Principal: TDataModule_Principal
  OldCreateOrder = False
  Height = 201
  Width = 235
  object CONNECTION: TZConnection
    Left = 42
    Top = 54
  end
  object QUERY: TZReadOnlyQuery
    Connection = CONNECTION
    Params = <>
    Left = 42
    Top = 102
  end
  object ComPort_Modem: TComPort
    BaudRate = br115200
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar]
    Buffer.InputSize = 16384
    Buffer.OutputSize = 16384
    FlowControl.OutCTSFlow = True
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsHandshake
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = []
    TriggersOnRxChar = False
    Left = 144
    Top = 6
  end
  object ComDataPacket_REC: TComDataPacket
    ComPort = ComPort_Modem
    IncludeStrings = True
    MaxBufferSize = 16384
    OnPacket = ComDataPacket_RECPacket
    OnCustomStart = ComDataPacket_RECCustomStart
    OnCustomStop = ComDataPacket_RECCustomStop
    Left = 138
    Top = 66
  end
  object ComDataPacket_REC2: TComDataPacket
    ComPort = ComPort_Modem
    OnPacket = ComDataPacket_REC2Packet
    OnCustomStart = ComDataPacket_REC2CustomStart
    OnCustomStop = ComDataPacket_REC2CustomStop
    Left = 138
    Top = 114
  end
  object Timer_Verificacoes: TTimer
    Enabled = False
    OnTimer = Timer_VerificacoesTimer
    Left = 42
    Top = 6
  end
end
