object DataModule_Principal: TDataModule_Principal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 207
  Width = 203
  object FtpClient_Principal: TFtpClient
    Timeout = 600
    MultiThreaded = False
    Port = '4321'
    CodePage = 0
    DataPortRangeStart = 0
    DataPortRangeEnd = 0
    LocalAddr = '0.0.0.0'
    DisplayFileFlag = False
    Binary = True
    ShareMode = ftpShareExclusive
    Options = [ftpAcceptLF]
    ConnectionType = ftpDirect
    Language = 'EN'
    OnDisplay = FtpClient_PrincipalDisplay
    OnCommand = FtpClient_PrincipalCommand
    OnResponse = FtpClient_PrincipalResponse
    OnProgress64 = FtpClient_PrincipalProgress64
    OnSessionClosed = FtpClient_PrincipalSessionClosed
    OnRequestDone = FtpClient_PrincipalRequestDone
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Left = 43
    Top = 6
  end
  object ActionList_Principal: TActionList
    Left = 43
    Top = 52
    object Action_AtualizarAgora: TAction
      Caption = 'Atualizar Imediatamente'
      OnExecute = Action_AtualizarAgoraExecute
    end
    object Action_EsconderNaBarraDeTarefas: TAction
      Caption = 'Esconder tela'
      OnExecute = Action_EsconderNaBarraDeTarefasExecute
    end
    object Action_RestaurarTela: TAction
      Caption = 'Restaurar tela'
      OnExecute = Action_RestaurarTelaExecute
    end
    object Action_FecharAplicacao: TAction
      Caption = 'Fechar o MPS Updater'
      OnExecute = Action_FecharAplicacaoExecute
    end
    object Action_SalvarLOG: TAction
      Caption = 'Salvar LOG'
      OnExecute = Action_SalvarLOGExecute
    end
  end
  object TrayIcon_Principal: TTrayIcon
    Hint = 'O MPS Updater ainda est'#225' ativo!'
    BalloonHint = 
      'Clique neste '#237'cone com o bot'#227'o direito do mouse para acessar o m' +
      'enu do MPS Updater'
    BalloonTitle = 'O MPS Updater ainda est'#225' ativo!'
    BalloonTimeout = 1000
    BalloonFlags = bfInfo
    Icon.Data = {
      0000010001001010000001001800680300001600000028000000100000002000
      000001001800000000000000000000000000000000000000000000000000005A
      00000000000000000000002000014902005900005A00005A0000580000400000
      1500000000000000000000000000005A00005A00003801005201056809189F26
      1FB7321EB9301BB42B10961906790B005A00004400000400000000000000005A
      002EC44A0A72101CA22E2CC94628C54021B8350A7B11005A0000540100520100
      5900005A00005100000600000000005A0036D25636D55632D1502ECD4A23B437
      015C01003500000700000000000000000000001C00005400004500000000005A
      0039D55A39D95A35D4542ECA4A015E03001C0000000000000000000000000000
      0000000000000600003900000000005A003CD95E3CDC5F38D85832CF4F005A00
      003000000000000000000000000000000000000000000000000000000000005A
      0030C04C30C44D2EC0482BBD4323AF37005A0000300000000000000000000000
      0000000000000000000000000000005A00005A00005A00005A00005A00005A00
      005A00005A000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000005A00005A00005A0000
      5A00005A00005A00005A00005A00000000000000000000000000000000000000
      000000000000000000005A0038D0593EDE623BDB5C37D75633D251005A000000
      00000000000000000000000000000000000000000000000000000000005A003F
      DD633FDF633BDB5D37D758005A00000000013D03000E00000000000000000000
      00000000000000000000200003600541DF6842E46A3FDF643CDC5E005A000000
      00013D02005901002800000500000000000000000C00013D020463083FD8664A
      ED7747EA7043E56A3FE165005A00000000000100024E04005A00005A00015A03
      005A0103610525A13B50F08053F7834FF37D28AC3F005A0038CF59005A000000
      00000000000100013902015C031B922D3CCA5E58FA8A5AFF8F4EEB7C30B94D08
      680D025003003100005A00005A00000000000000000000000000000E00013501
      035806005A00005A00015902024404000000000000000000002B00005A00700F
      000000030000000100000071000001F9000001FF000000FF000000FF0000FF00
      0000FF800000FFC000009F8000008600000080000000C0000000F01C0000}
    PopupMenu = PopupMenu_TrayIcon
    OnDblClick = Action_RestaurarTelaExecute
    Left = 43
    Top = 102
  end
  object PopupMenu_TrayIcon: TPopupMenu
    Left = 43
    Top = 156
    object Restaurartela1: TMenuItem
      Action = Action_RestaurarTela
      Default = True
    end
    object VerificarImediatamente1: TMenuItem
      Action = Action_AtualizarAgora
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object FecharoMPSUpdater1: TMenuItem
      Action = Action_FecharAplicacao
    end
  end
end
