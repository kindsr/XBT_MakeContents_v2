unit frmToolTip;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, uConst, uQuery,
  scGPExtControls, scControls, scGPControls, Vcl.ComCtrls, Data.DB, DBAccess,
  Uni, MemDS;

type
  TPageNames = (pgProcImage, pgProcAllFiles, pgPackage, pgImageUpload);

const
  pageProcImage : string = '1. 장비의 컬러/흑백 출력 부분을 캡쳐보드에 연결합니다.'
            + sLineBreak + '   1.1 컬러/흑백을 출력하지 않는 경우 장비별 환경설정을 통하여 '
            + sLineBreak + '       영상 출력설정을 변경합니다.'
            + sLineBreak + '   1.2 예로 스미스(통제기술원) X-Ray 장비의 경우 관리자 계정으로 '
            + sLineBreak + '       접속(ID:004, PW:94866)하여 머신 설정이 가능합니다.'
            + sLineBreak + ''
            + sLineBreak + '2. 캡쳐보드의 해상도는 1280 * 1024로 캡쳐 이미지의 저장경로는 '
            + sLineBreak + '   임의의 폴더를 지정합니다.'
            + sLineBreak + '   2.1 콘텐츠 촬영의 순서 및 기초데이터를 작성하기 위하여 콘텐츠 '
            + sLineBreak + '   작업용 Excel을 준비합니다.'
            + sLineBreak + ''
            + sLineBreak + '3. 캡쳐를 받는 순서는 다음과 같습니다. (예:스미스)'
            + sLineBreak + '   3.1 normal(1컷) -> O2(1컷) -> HI(1컷) -> NEG(1컷) -> '
            + sLineBreak + '       (normal -> 최소 깊이 -> 깊이 15 상승 = 1 컷)'
            + sLineBreak + '       -> 깊이 15 상승(1컷) -> 깊이 5 상승(1컷) -> 깊이 5 상승(1컷) '
            + sLineBreak + '       -> 깊이 5 상승(1컷) -> 깊이 5 상승(1컷)'
            + sLineBreak + '   3.2 총 10장의 유형을 캡쳐하며 컨텐츠의 총 수량은'
            + sLineBreak + '       정면 컬러 + 10 / 정면 흑백 + 10 / 측면 컬러 + 10 / '
            + sLineBreak + '       측면 흑백 + 10 / 정면 정답(normal) +1 / 측면 정답(normal) +1 / '
            + sLineBreak + '       실사 사진으로 총 43장(정답이 없는 통과 물품의 경우 41장)의 '
            + sLineBreak + '       컨텐츠가 촬영되어야 합니다.'
            + sLineBreak + ''
            + sLineBreak + '4. 캡쳐보드를 통하여 저장되는 이미지파일의 위치에 XBT Make Contents '
            + sLineBreak + '   Tool(이하 MCT) 을 복사합니다.'
            + sLineBreak + '   4.1 MCT 이미지 처리 초기 설정은 다음과 같습니다.'
            + sLineBreak + '   4.2 예) 가방 X-Ray 콘텐츠 생성 시'
            + sLineBreak + '           정면 : 메인 시작번호 = X0001, 서브 시작번호 1 부터 '
            + sLineBreak + '           20 개 파일, 전체 폴더 검증 22개'
            + sLineBreak + '           측면 : 메인 시작번호 = X0001, 서브 시작번호 2 부터 '
            + sLineBreak + '           20 개 파일, 전체 폴더 검증 20개'
            + sLineBreak + '       예) 물품 X-Ray 콘텐츠 생성 시'
            + sLineBreak + '           정면 : 메인 시작번호 = U0001, 서브 시작번호 1 부터 '
            + sLineBreak + '           5 개 파일, 전체 폴더 검증 5개'
            + sLineBreak + '           측면 : 메인 시작번호 = U0001, 서브 시작번호 2 부터 '
            + sLineBreak + '           5 개 파일, 전체 폴더 검증 5개'
            + sLineBreak + '   4.3 정면의 경우 정면/측면 normal X-Ray 이미지가 정답으로 복사되어 '
            + sLineBreak + '       생성되어 22개의 파일이 생성됩니다.'
            + sLineBreak + '   4.4 정상적으로 하나의 가방이 이동된다면 현재 진행 번호 및 다음 '
            + sLineBreak + '       번호가 다음 순번으로 변경됩니다.'
            + sLineBreak + ''
            + sLineBreak + '5. 1차 이미지 작업 (물품 콘텐츠 생성)'
            + sLineBreak + '   5.1 촬영할 물품의 실제 사진을 촬영합니다.'
            + sLineBreak + '   5.2 물품을 X-Ray 장비를 이용하여 X-Ray 이미지 작업을 진행합니다.'
            + sLineBreak + '   5.1 캡쳐된 이미지가 정면 5장 / 측면 5장이 생성된 후 MCT 이미지처리 '
            + sLineBreak + '       실행 버튼을 클릭 '
            + sLineBreak + '   5.2 프로그램은 프로그램 설치 위치 하부 -> 메인 시작번호로 폴더 '
            + sLineBreak + '       자동 생성'
            + sLineBreak + '   5.3 생성된 폴더에 메인 시작번호 + 101 ~ 105 (정면 컬러) '
            + sLineBreak + '       메인 시작번호 + 201 ~ 205 (정면 흑백)이 자동분류 됩니다.'
            + sLineBreak + ''
            + sLineBreak + '6. 1차 이미지 작업 (가방 콘텐츠 생성)'
            + sLineBreak + '   6.1 촬영한 가방의 구성 물품의 꾸러미 사진을 촬영합니다.'
            + sLineBreak + '   6.1 캡쳐된 이미지가 정면 20장 / 측면 20장이 생성된 후 MCT '
            + sLineBreak + '       이미지처리 실행 버튼을 클릭 '
            + sLineBreak + '   6.2 프로그램은 프로그램 설치 위치 하부 -> 메인 시작번호로 '
            + sLineBreak + '       폴더 자동 생성'
            + sLineBreak + '   6.3 생성된 폴더에 메인 시작번호 + 101 ~ 110 (정면 컬러), 메인 '
            + sLineBreak + '       시작번호 + 111 ~ 120 (측면 컬러)'
            + sLineBreak + '       메인 시작번호 + 201 ~ 210 (정면 흑백), '
            + sLineBreak + '       메인 시작번호 + 210 ~ 220 (측면 흑백)'
            + sLineBreak + '       메인 시작번호 + 401 (정면 normal 컬러 정답), '
            + sLineBreak + '       메인 시작번호 + 402 (측면 normal 컬러 정답)가 자동분류 됩니다.'
            + sLineBreak + ''
            + sLineBreak + '7. 5번 6번의 작업을 통하여 X-Ray 장비를 이용한 촬영을 마무리 한다.'
            + sLineBreak + '   7.1 작업이 완료 된 후 디렉토리는 컬러/흑백 두가지의 폴더가 '
            + sLineBreak + '       동일한 폴더구조로 생성되어 마무리 됩니다.';



  pageProcAllFiles: string = '8. 2차 이미지 작업 (리사이징)'
              + sLineBreak + '   8.1 1차 이미지 작업을 통하여 생성된 BMP 파일을 JPG 이미지로 '
              + sLineBreak + '       변경합니다. '
              + sLineBreak + '   8.2 만약 촬영 이미지가 1280 * 1024 사이즈 이상이라면 '
              + sLineBreak + '       리사이즈(가로길이)에 1280을 입력 후 리사이즈 클릭시 해당 '
              + sLineBreak + '       사이즈로 리사이징이 됩니다.'
              + sLineBreak + ''
              + sLineBreak + '9. 3차 이미지 작업 (정측면 분리)'
              + sLineBreak + '   9.1 정측면 분리는 가방 콘텐츠의 정면과 측면 이미지를 분리하는 '
              + sLineBreak + '       작업입니다.'
              + sLineBreak + '   9.2 분리는 콘텐츠 파일의 컬러/흑백에 대한 파일의 '
              + sLineBreak + '       101~110, 201~210, 401~402 (정면), 111~120, 211~220 (측면)의 '
              + sLineBreak + '       기준으로 분리합니다.'
              + sLineBreak + '   9.2 리사이징이 완료된 후 MCT 파일일괄처리에 리사이징이 완료된 '
              + sLineBreak + '       디렉토리를 선택합니다.'
              + sLineBreak + '   9.3 Sub 폴더 항목에 임의의 값(예: 정면/측면)을 입력합니다.'
              + sLineBreak + '   9.4 정측면 분리를 실행 시 콘텐츠는 9.2 내용의 규칙에 의해 '
              + sLineBreak + '       정면 X-Ray 이미지와 측면 X-Ray 이미지가 동일한 디렉토리 '
              + sLineBreak + '       구조를 가진 두개의 폴더로 나눠집니다.'
              + sLineBreak + ''
              + sLineBreak + '11. 5차 이미지 작업 (크롭/나누기)'
              + sLineBreak + '   11.1 크롭은 JPGCrops Tool을 이용하여 진행합니다.'
              + sLineBreak + '   11.2 크롭이 완료된 이미지는 하나의 폴더에 콘텐츠 파일명으로 '
              + sLineBreak + '        위치하게됩니다.'
              + sLineBreak + '        다시 콘텐츠 폴더 구조를 가지기 위해 나누기 버튼을 클릭하여 '
              + sLineBreak + '        크롭하기 전 폴더 구조로 복원합니다.';

  pagePackage : string = '10. 4차 이미지 작업 (패키징)'
          + sLineBreak + '   10.1 콘텐츠는 n개의 가방을 이용 반복 작업을 합니다. X-Ray 가방은 '
          + sLineBreak + '        모양에 따라 촬영되는 이미지가 유사한 크롭영역을 가지게 됩니다.'
          + sLineBreak + '        크롭의 일괄처리를 위하여 콘텐츠 작업용으로 작업한 Excel을 이용'
          + sLineBreak + '        콘텐츠ID와 가방ID를 조회하여 가방별로 이미지를 패키징합니다.';

  pageImageUpload : string = '12. 6차 이미지 작업 (DB 업로드)'
              + sLineBreak + '   12.1 크롭이 완료된 이미지와 데이터가 정리된 Excel파일을 준비합니다.'
              + sLineBreak + '   12.2 디비에 접속하여 엑셀을 선택합니다.'
              + sLineBreak + '   12.3 업로드할 이미지의 폴더를 선택합니다.'
              + sLineBreak + '   12.4 비교 키값이 될 항목의 엑셀 해더를 선택합니다.'
              + sLineBreak + '   12.5 엑셀을 업로드 하고 이미지를 업로드 합니다. ';


type
  TToolTip = class(TForm)
    Panel1: TPanel;
    btnClose: TscGPButton;
    mmToolTip: TscGPMemo;
    qryToolTip: TUniQuery;
    DBConn: TUniConnection;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Clear(caArea: TClearArea);
    procedure LoadToolTip(var slList: TStringList; const FromNum, ToNum: Integer); overload;
    procedure LoadToolTip(pageName: TPageNames); overload;
    { Public declarations }
  end;

var
  ToolTip: TToolTip;

implementation

{$R *.dfm}

procedure TToolTip.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TToolTip.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  ToolTip := nil;
end;

procedure TToolTip.FormCreate(Sender: TObject);
begin
  Clear(caAll);
end;

procedure TToolTip.Clear(caArea: TClearArea);
var
  i, j: Integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if caArea in [caAll] then
    begin
      if Components[i].ClassType = TLabel then
      begin
        if Pos('lbl',TLabel(Components[i]).Name) > 0 then
        begin
          TLabel(Components[i]).Caption := '';
        end;
      end
      else if Components[i].ClassType = TEdit then
      begin
        if Pos('edt',TEdit(Components[i]).Name) > 0 then
        begin
          TEdit(Components[i]).Text := '';
        end;
      end
      else if Components[i].ClassType = TscGPMemo then
      begin
        if Pos('mm',TscGPMemo(Components[i]).Name) > 0 then
        begin
          TscGPMemo(Components[i]).Lines.Clear;
        end;
      end;
    end;
  end;
end;

procedure TToolTip.LoadToolTip(var slList: TStringList; const FromNum, ToNum: Integer);
begin
  mmToolTip.Lines.Clear;
  slList.Clear;

  if not DBConn.Connected then DBConn.Connect;

  with qryToolTip do
  begin
    SQL.Text := SEL_TOOLTIP;

    ParamCheck := True;
    ParamByName('fromnum').AsInteger := FromNum;
    ParamByName('tonum').AsInteger := ToNum;

    Open;
    First;

    while not Eof do
    begin
      slList.Add(FieldByName('CONTENT').AsString);
      Next;
    end;
  end;
end;

procedure TToolTip.LoadToolTip(pageName: TPageNames);
begin
  mmToolTip.Lines.Clear;
  case pageName of
    pgProcImage: mmToolTip.Lines.Add(pageProcImage);
    pgProcAllFiles: mmToolTip.Lines.Add(pageProcAllFiles);
    pgPackage: mmToolTip.Lines.Add(pagePackage);
    pgImageUpload: mmToolTip.Lines.Add(pageImageUpload);
  end;
end;


end.
