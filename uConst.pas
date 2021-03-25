unit uConst;

interface

uses
  DB;

type
  TClearArea = (caAll, caAction, caLog, caImage, caUpload);
  TActFunction = (afCount, afPreCount, afMoveFile, afResize, afResizeAll,
                  afRenameOnly, afSeperate, afPackage, afUploadImage, afDevide,
                  afCompWH, afProgressCount, afLoadImage);

type
  TColumnInfo = record
    colName: string;
    colType: TFieldType;
    colLength: Integer;
    blobFinish: Boolean;
  end;

  TInfoTable = record
    tableName: string;
    colInfo: array of TColumnInfo;
    colCount: Integer;
    blobCount: Integer;
  end;

type
  TConfigInfo = record
    OverlayMode: Boolean;
    Animation: Boolean;
    CompactWidth: Integer;
    SkinComboIndex: Integer;
    Maximize: Boolean;
    Sizable: Boolean;
    StayOnTop: Boolean;
  end;

implementation

end.
