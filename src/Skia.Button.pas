unit Skia.Button;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  System.UITypes,
  Vcl.Controls,
  Skia,
  Skia.Vcl;

type
  TSkButton = class(TSkCustomWinControl)
  private
    FCaption    : String;
    FColor      : TAlphaColor;
    FBorderWidth: Integer;
    FSkFont     : ISkFont;

    function getText: String;
    procedure SetText(const Value: String);
    function getBorderShow: Boolean;
    procedure SetBorderShow(const Value: Boolean);
    function GetBorderWidth: Integer;
    procedure SetBorderWidth(const Value: Integer);
    procedure SetColor(const Value: TAlphaColor);
    function GetColor: TAlphaColor;
    procedure SetFontSize(const Value: Single);
    function GetFontSize: Single;

  protected
    FSkPaint    : ISkPaint;
    FSkFontPaint: ISkPaint;
    FSkCanvas   : ISkCanvas;
    FBorderShow : Boolean;

    procedure DoDraw(ASender: TObject; const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
    procedure DoMouseEnter(AObject: TObject);
    procedure DoMouseLeave(AObject: TObject);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property Caption    : String        read getText        write SetText;
    property FontSize   : Single        read GetFontSize    write SetFontSize;
    property BorderShow : Boolean       read getBorderShow  write SetBorderShow;
    property BorderWidth: Integer       read GetBorderWidth write SetBorderWidth;
    property Color      : TAlphaColor   read GetColor       write SetColor;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Skia', [TSkButton]);
end;

{ TSkButton }

constructor TSkButton.Create(AOwner: TComponent);
begin
  inherited;

  Self.Cursor       := crHandPoint;
  Self.FColor       := TAlphaColorRec.Black;
  Self.FBorderWidth := 2;
  Self.FBorderShow  := True;
  Self.Width        := 50;
  Self.Height       := 20;
  Self.FCaption     := Self.Name;

  FSkPaint           := TSkPaint.Create(TSkPaintStyle.Stroke);
  FSkPaint.AntiAlias := True;

  Self.OnDraw       := DoDraw;
  Self.OnMouseEnter := DoMouseEnter;
  Self.OnMouseLeave := DoMouseLeave;

  FSkFontPaint           := TSkPaint.Create(TSkPaintStyle.Fill);
  FSkFontPaint.AntiAlias := True;

  FSkFont      := TSkFont.Create();
  FSkFont.Size := 12;
 end;

destructor TSkButton.Destroy;
begin

  inherited;
end;

procedure TSkButton.DoDraw(ASender: TObject; const ACanvas: ISkCanvas; const ADest: TRectF; const AOpacity: Single);
var
  LRect: TRectF;
  X,Y: Single;
begin
  LRect := TRectF.Create(PointF(5, 5), PointF(Self.Width - FBorderWidth, Self.Height - FBorderWidth));
  LRect.Offset(0, 0);

  FSkPaint.Color       := FColor;
  FSkPaint.StrokeWidth := Single(FBorderWidth);

  FSkFontPaint.Color := FColor;

  if BorderShow then
    ACanvas.DrawRoundRect(LRect, Single(FBorderWidth), Single(FBorderWidth), FSkPaint)
  else
    ACanvas.Discard;

  FSkFont.MeasureText(FCaption, LRect, FSkFontPaint);

  X := ((ADest.Width - LRect.Right) / 2);
  Y := ((ADest.Height - LRect.Top) / 2);

  ACanvas.DrawSimpleText(FCaption, X, Y, FSkFont, FSkFontPaint);
end;

procedure TSkButton.DoMouseEnter(AObject: TObject);
begin
  Self.Opacity := 100;
end;

procedure TSkButton.DoMouseLeave(AObject: TObject);
begin
  Self.Opacity := 255;
end;

function TSkButton.getBorderShow: Boolean;
begin
  Result := FBorderShow;
end;

function TSkButton.GetBorderWidth: Integer;
begin
  Result := FBorderWidth;
end;

function TSkButton.GetColor: TAlphaColor;
begin
  Result := FColor;
end;

function TSkButton.GetFontSize: Single;
begin
  Result := FSkFont.Size;
end;

function TSkButton.getText: String;
begin
  Result := FCaption;
end;

procedure TSkButton.SetBorderShow(const Value: Boolean);
begin
  FBorderShow := Value;
  Self.Redraw;
end;

procedure TSkButton.SetBorderWidth(const Value: Integer);
begin
  if Value > 0 then
    FBorderWidth := Value
  else
    FBorderWidth := 1;

  FSkPaint.StrokeWidth := FBorderWidth;
  Self.Redraw;
end;

procedure TSkButton.SetColor(const Value: TAlphaColor);
begin
  FColor := Value;
  Self.Redraw;
end;

procedure TSkButton.SetFontSize(const Value: Single);
begin
  FSkFont.Size := Value;
  Self.Redraw;
end;

procedure TSkButton.SetText(const Value: String);
begin
  FCaption := Value;
  Self.Redraw;
end;

end.
