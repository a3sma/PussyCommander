object frmContact: TfrmContact
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Contact'
  ClientHeight = 239
  ClientWidth = 615
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 38
    Width = 615
    Height = 201
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 6
      Top = 9
      Width = 29
      Height = 13
      Caption = 'Group'
    end
    object Label3: TLabel
      Left = 6
      Top = 43
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object Label4: TLabel
      Left = 6
      Top = 70
      Width = 39
      Height = 13
      Caption = 'Phone 1'
    end
    object Label5: TLabel
      Left = 6
      Top = 98
      Width = 39
      Height = 13
      Caption = 'Phone 2'
    end
    object Label6: TLabel
      Left = 6
      Top = 128
      Width = 28
      Height = 13
      Caption = 'E-Mail'
    end
    object Label7: TLabel
      Left = 216
      Top = 70
      Width = 20
      Height = 13
      Caption = 'ext.'
    end
    object Label8: TLabel
      Left = 216
      Top = 98
      Width = 20
      Height = 13
      Caption = 'ext.'
    end
    object mmComment: TMemo
      Left = 319
      Top = 6
      Width = 283
      Height = 140
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object cmbGroup: TComboBox
      Left = 57
      Top = 6
      Width = 256
      Height = 21
      TabOrder = 1
    end
    object txtName: TEdit
      Left = 57
      Top = 40
      Width = 256
      Height = 21
      TabOrder = 2
    end
    object txtPhone1: TEdit
      Left = 57
      Top = 67
      Width = 153
      Height = 21
      TabOrder = 3
      OnChange = txtPhone1Change
      OnExit = txtPhone1Exit
    end
    object txtPhone2: TEdit
      Left = 57
      Top = 94
      Width = 153
      Height = 21
      TabOrder = 4
      OnChange = txtPhone2Change
      OnExit = txtPhone2Exit
    end
    object txtExt1: TEdit
      Left = 242
      Top = 67
      Width = 71
      Height = 21
      TabOrder = 5
      OnChange = txtPhone1Change
      OnExit = txtPhone1Exit
    end
    object txtExt2: TEdit
      Left = 242
      Top = 94
      Width = 71
      Height = 21
      TabOrder = 6
      OnChange = txtPhone1Change
      OnExit = txtPhone1Exit
    end
    object txtEmail: TEdit
      Left = 57
      Top = 125
      Width = 256
      Height = 21
      TabOrder = 7
      OnChange = txtPhone2Change
      OnExit = txtPhone2Exit
    end
    object pnBottom: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 165
      Width = 609
      Height = 33
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 8
      object btnSaveAndClose: TSpeedButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 133
        Height = 27
        Align = alLeft
        Caption = 'Save and close'
        Glyph.Data = {
          D6050000424DD6050000000000003600000028000000180000000F0000000100
          200000000000A005000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000020202060C0E
          0D2917271F5F1E4D35941E4E3698192C22660D100F2F02020208000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000404040D101412381B322670235A3EA3288A58D229B7
          70F628D07BFF1FA965FF10643BFF1B9B5AFF28B76EF9268958D7225D3FA91B36
          28761117143F050505110000000000000000000000000000000001010105131D
          18491D49338D207349BB1D9E5DE31CC46FFD1CD477FF20DA7CFF21DA7DFF21D7
          7BFF1AA962FF1B883AFF165B28FF083823FF159654FF1AC46EFF1AC16CFF1DBD
          6CFF24B36BFE26955CE7236F48C01F4C359315221B5202020209020202071524
          1C561D5E3DA31B9C5ADC18C66EFA14D473FF13D874FF14D976FF16D776FF10A7
          5CFF0B7F2CFF59CE5FFF59D964FF1A5F2EFF02321DFF0B8E4BFF0DBB63FF0CBA
          61FF11B561FF1EB166FC21945AE01F613FAA162B20600303030C000000000000
          00000000000001010104080A091F131F194B1C433080197447BD0F8A4DEF0A7A
          2AFF3CC646FF6CFF7BFF72FF7EFF43D44FFF105E23FE042E1CFD0C6137DD1540
          2A8713211A4F0A0D0B2402020206000000000000000000000000000000000000
          000000000000000000000000000000000000000000000101012F043707BE2DBB
          38FF54F162FF71F37DFF64F673FF58FB66FF35CD41FB0B3A0ED0010000AC0100
          0034000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000002509310CB720AF2CFF53DF
          60FF80E68AFF8FEB97FF7FEA89FF58E966FF4AF059FF2DB636F3042E06CC0000
          00B4000000450000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000011D4320903FAE49FF63D36DFF94DF
          9CFF92E19AFF58C461F775D57DFA7BE284FF4BDB59FF3BDF4BFF229D2AF50025
          02CD000000B50000004500000000000000000000000000000000000000000000
          00000000000000000000000000000007000F3E8845D09BD8A1FFAADCAFFF9DDB
          A3FF4AB554F20334084E125218715ECE69FF75D87FFF3FCD4DFF2ACF3AFF198A
          22F6001B02CD000000B600000049000000000000000000000000000000000000
          00000000000000000000000000000000000002150425409949D5B3D9B7FF4EAE
          57F0002E044B0000000000000000074D0E7256C360FF6ECE77FF32BF3FFF17BE
          26FF127F1CF6011702CE000000B80000004E0000000200000000000000000000
          0000000000000000000000000000000000000000000000170225228029BA022E
          0649000000000000000000000000000000000243086C4FB458FE6AC273FF26AE
          33FF03AA12FF0E7C18F8112613D1000000A80000001D00000000000000000000
          0000000000000000000000000000000000000000000000000000000100010000
          00000000000000000000000000000000000000000000023E076A51AB59FC6CB1
          73FF25962FFF008C09FF328639FF041305850000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000023D066450A6
          58FA73A978FF2F8837FF05590CDD000D012C0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000000000000023A
          065F59AA60FE48894ED8000F0128000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000012903480115032900000000000000000000000000000000}
        OnClick = btnSaveAndCloseClick
        ExplicitLeft = 8
        ExplicitTop = 0
        ExplicitHeight = 25
      end
      object btnClose: TButton
        AlignWithMargins = True
        Left = 531
        Top = 3
        Width = 75
        Height = 27
        Align = alRight
        Caption = 'Close'
        TabOrder = 0
        OnClick = btnCloseClick
      end
    end
  end
  object pnISDEL: TPanel
    Left = 0
    Top = 0
    Width = 615
    Height = 38
    Align = alTop
    BevelInner = bvRaised
    BorderStyle = bsSingle
    Color = clInfoBk
    ParentBackground = False
    TabOrder = 1
    Visible = False
    object Label1: TLabel
      Left = 6
      Top = 10
      Width = 143
      Height = 13
      Caption = 'This record marked as archive'
    end
    object sbtnRestore: TSpeedButton
      Left = 170
      Top = 5
      Width = 92
      Height = 25
      Caption = 'Restore'
      Flat = True
      Glyph.Data = {
        36090000424D3609000000000000360000002800000018000000180000000100
        2000000000000009000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000004F0000009E000000BE000000BE0000007F0000002F000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000000000000000002F0000
        00D6000000FF000000FF000000FF000000FF000000FF000000FF0000008E0000
        0007000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000037000000EE0000
        00FF000000E60000006F0000003F0000004F00000096000000FF000000FF0000
        00AE000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000007000000DE000000FF0000
        00A600000007000000000000000000000000000000000000002F000000EE0000
        00FF0000006F0000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000000000000000002F0000008E0000
        00000000000000000000000000000000000000000000000000000000004F0000
        00FF000000E60000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00D6000000FF0000003700000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00BE000000FF0000004F00000000000000000000000000000000000000000000
        00000000000000000000000000000000009E000000FF000000FF000000FF0000
        00FF000000FF000000FF00000000000000000000000000000000000000000000
        00C6000000FF0000005700000000000000000000000000000000000000000000
        00000000000000000000000000000000009E000000FF000000FF000000FF0000
        00FF000000FF000000FF00000000000000000000000000000000000000070000
        00F6000000FF0000001700000000000000000000000000000000000000000000
        00000000000000000000000000000000009E000000FF000000FF000000FA0000
        008F0000007F0000007F00000000000000000000000000000000000000860000
        00FF000000C60000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000009E000000FF000000FF000000FF0000
        00DE00000037000000000000000000000000000000070000007F000000FF0000
        00F60000002F0000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000009E000000FF000000FF000000C60000
        00FF000000FF000000CE0000007F000000A6000000F6000000FF000000FF0000
        0067000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000009E000000FF000000FF000000000000
        0086000000EE000000FF000000FF000000FF000000FF000000CE000000370000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000004F0000007F0000007F000000000000
        000000000000000000570000007F0000006F0000001F00000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      OnClick = sbtnRestoreClick
    end
    object sbtnDelete: TSpeedButton
      Left = 260
      Top = 5
      Width = 92
      Height = 25
      Caption = 'Delete'
      Flat = True
      Glyph.Data = {
        1A070000424D1A07000000000000360000002800000015000000150000000100
        200000000000E406000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000034000000D80000007A0000000000000000000000000000
        00000000000000000000000000000000007A000000D800000036000000000000
        0000000000000000000000000000000000000000000000000022000000C60000
        00FF000000FC0000005D00000000000000000000000000000000000000000000
        0059000000FA000000FF000000C9000000240000000000000000000000000000
        0000000000000000001D000000BC000000FF000000FF000000FF000000FC0000
        00600000000000000000000000000000005F000000FC000000FF000000FF0000
        00FF000000BC0000001C00000000000000000000000000000000000000010000
        0063000000FF000000FF000000FF000000FF000000FF0000005D000000000000
        005B000000FE000000FF000000FF000000FF000000FF00000064000000010000
        000000000000000000000000000000000000000000000000005C000000FA0000
        00FF000000FF000000FF000000E8000000A0000000E7000000FF000000FF0000
        00FF000000FA0000005D00000000000000000000000000000000000000000000
        00000000000000000000000000000000005B000000FB000000FF000000FF0000
        00FF000000FF000000FF000000FF000000FF000000FD0000005F000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000058000000F5000000FF000000FF000000FF000000FF0000
        00FF000000F70000005C00000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        009E000000FF000000FF000000FF000000FF000000FF000000A2000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000058000000F5000000FF000000FF0000
        00FF000000FF000000FF000000F70000005B0000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        005C000000FB000000FF000000FF000000FF000000FF000000FF000000FF0000
        00FF000000FD0000006000000000000000000000000000000000000000000000
        00000000000000000000000000000000005C000000FA000000FF000000FF0000
        00FF000000E80000009F000000E7000000FF000000FF000000FF000000FA0000
        005E000000000000000000000000000000000000000000000000000000010000
        0063000000FF000000FF000000FF000000FF000000FF0000005D000000000000
        005B000000FE000000FF000000FF000000FF000000FF00000064000000010000
        00000000000000000000000000000000001C000000BC000000FF000000FF0000
        00FF000000FC0000005F0000000000000000000000000000005F000000FC0000
        00FF000000FF000000FF000000BC0000001C0000000000000000000000000000
        00000000000000000022000000C6000000FF000000FC0000005D000000000000
        00000000000000000000000000000000005A000000FA000000FF000000C90000
        0024000000000000000000000000000000000000000000000000000000000000
        0034000000D90000007B00000000000000000000000000000000000000000000
        0000000000000000007B000000D9000000360000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000000000000000000000000000}
      OnClick = sbtnDeleteClick
    end
  end
end
