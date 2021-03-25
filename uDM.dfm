object DM: TDM
  OldCreateOrder = False
  Height = 194
  Width = 253
  object UniConnection1: TUniConnection
    ProviderName = 'Oracle'
    Port = 9005
    SpecificOptions.Strings = (
      'Oracle.Direct=True')
    Username = 'XBT_DEV'
    Server = 'file.g-antech.com'
    AfterConnect = UniConnection1AfterConnect
    AfterDisconnect = UniConnection1AfterDisconnect
    Left = 56
    Top = 16
    EncryptedPassword = 'A7FFBDFFABFFCEFFCDFFCCFF'
  end
  object dsTables: TUniDataSource
    DataSet = qryTables
    Left = 120
    Top = 16
  end
  object qryTables: TUniQuery
    Connection = UniConnection1
    SQL.Strings = (
      'select table_name from all_tables'
      'where owner = '#39'XBT_DEV'#39)
    Left = 184
    Top = 16
  end
  object SQLServerUniProvider1: TSQLServerUniProvider
    Left = 56
    Top = 72
  end
  object OracleUniProvider1: TOracleUniProvider
    Left = 160
    Top = 72
  end
  object qryDBGrid: TUniQuery
    Connection = UniConnection1
    Left = 120
    Top = 136
  end
  object dsDBGrid: TUniDataSource
    DataSet = qryDBGrid
    Left = 48
    Top = 136
  end
  object qryCRUD: TUniQuery
    Connection = UniConnection1
    Left = 184
    Top = 136
  end
end
