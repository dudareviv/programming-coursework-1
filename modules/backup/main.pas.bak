unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Math, Arrays, Numbers;

type
  { TForm1 }

  TForm1 = class(TForm)
    RangeDEditBox: TEdit;
    RangeFEditBox: TEdit;
    RangeGEditBox: TEdit;
    RangeCEditBox: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    SourceArrayMemo: TMemo;
    LogMemo: TMemo;
    SortedArrayMemo: TMemo;
    CompressedArrayMemo: TMemo;
    PerfectNubmersMemo: TMemo;
    procedure MainChangeHandler(Sender: TObject);
    procedure MemoKeyPressHandler(Sender: TObject; var Key: char);
    procedure RangeKeyPressHandler(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end;

const
  maxLineLength = 4;
  maxLinesCount = 15;

var
  Form1: TForm1;
  arrA, arrB, arrTemp, arrPerfect: TArrayInt;
  ranges: TArrayRanges;
  compressed: integer;

implementation

{$R *.lfm}

{ TForm1 }


{Данная процедура отвечает за все расчеты связанные с курсовой работой

Ее задачи:
1. Собрать исходный массив А
2. Получить диапазоны значений
3. Если какое-либо из полей будет пустым, сообщить об этом
4. Выполнить следующие задания:
   1. Найти последнее максимальное значение массива А
   2. Выполнить сортировку массива А методом прямого выбора
   3. Сжать массив А, удалив из него элементы, значения которых принадлежат
отрезкам [c,d]^[f,g]
      Если таких элементов нет, то вывести сообщение
   4. Сформировать массив B из элементов массива А, являющихся совершенными
числами
   }
procedure TForm1.MainChangeHandler(Sender: TObject);
var
  i, i_max, linesCount: integer;
begin
  LogMemo.Clear;

  {Собираем исходный массив A}
  {---------------------------------------}
  with SourceArrayMemo do
  begin
    linesCount := Lines.Count;

    SetLength(arrA, 0);

    for i := 0 to linesCount - 1 do
    begin
      if (Length(Lines[i]) > 0) and (Lines[i][1] <> '-') or
        (Length(Lines[i]) > 1) and (Lines[i][1] = '-') then
      begin
        SetLength(arrA, Length(arrA) + 1);
        arrA[High(arrA)] := StrToInt(Lines[i]);
      end;
    end;

    LogMemo.Lines.Add('Кол-во строк: ' + IntToStr(linesCount));
    LogMemo.Lines.Add('Исходный массив');
    LogMemo.Lines.Add(' Длина: ' + IntToStr(Length(arrA)));
  end;
  {---------------------------------------}


  {Получаем диапазоны значений}
  {---------------------------------------}
  hasError := False;
  SetLength(ranges, 2);

  setRange(RangeCEditBox.Text, RangeDEditBox.Text, ranges[0]);
  setRange(RangeFEditBox.Text, RangeGEditBox.Text, ranges[1]);

  if (hasError) then
  begin
    ShowMessage(errorMessage);
    Exit;
  end;
  {---------------------------------------}


  {Поиск последнего максимального значения}
  {---------------------------------------}
  i_max := arraySearch(arrA, False);
  if (i_max >= 0) then
  begin
    LogMemo.Lines.Add('Максимальное значение');
    LogMemo.Lines.Add(' Индекс: ' + IntToStr(i_max));
    LogMemo.Lines.Add(' Значение: ' + IntToStr(arrA[i_max]));
  end;
  {---------------------------------------}

  {Сортировка массива методом прямого выбора}
  {---------------------------------------}
  arraySort(arrA);
  arrayPrint(arrA, SortedArrayMemo);
  {---------------------------------------}


  {Компрессия массива}
  {---------------------------------------}
  compressed := 0;
  arrayCompress(arrA, ranges, compressed);

  LogMemo.Lines.Add('Компрессия массива');
  if (compressed > 0) then
  begin
    LogMemo.Lines.Add(' Успех, элементов было удалено: ' +
      IntToStr(compressed));
  end
  else
  begin
    LogMemo.Lines.Add(
      ' Неудача, элементов для удалений не найдено.');
  end;

  arrayPrint(arrA, CompressedArrayMemo);
  {---------------------------------------}


  {Собираем массив совершенных чисел}
  {---------------------------------------}
  SetLength(arrTemp, Length(arrA));
  arrTemp := arrA;

  for i := High(arrTemp) downto Low(arrTemp) do
  begin
    if (not isPerfect(arrTemp[i])) then
    begin
      arrayRemove(arrTemp, i);
    end;
  end;

  arrayPrint(arrTemp, PerfectNubmersMemo);
  {---------------------------------------}
end;

{------------------------------------------------------------------------------}


{Обрабатываем ввод в доступный Memo}
procedure TForm1.MemoKeyPressHandler(Sender: TObject; var Key: char);
var
  linesCount, lineLength: integer;
  lineText: string;
begin
  with Sender as TMemo do
  begin
    linesCount := Lines.Count;
    lineLength := Length(Lines[CaretPos.Y]);
    lineText := Lines[CaretPos.Y];

    begin
      case Key of
        #8: ;//<backspace>
        #13://ввод
        begin
          if (linesCount >= maxLinesCount) then
            Key := #0;
        end;
        '0'..'9'://цифры
        begin
          if (lineLength > 0) and ((lineLength >= maxLineLength) and
            (lineText[1] <> '-') or (lineText[1] = '-') and
            (lineLength >= maxLineLength + 1)) then
          begin
            Key := #0;
          end;
        end;
        '-':
        begin
          if (CaretPos.X > 0) then
            Key := #0;
        end;
        else
          Key := #0;
      end;
    end;
  end;
end;

{------------------------------------------------------------------------------}


{Обработчик для строго числовых положительных значений}
procedure TForm1.RangeKeyPressHandler(Sender: TObject; var Key: char);
var
  textLength: integer;
begin
  with Sender as TEdit do
  begin

    textLength := Length(Text);
    case Key of
      #8: ;//<backspace>
      '0'..'9'://цифры
      begin
        if (textLength >= maxLineLength) then
        begin
          Key := #0;
        end;
      end;
      else
        Key := #0;
    end;
  end;
end;

{------------------------------------------------------------------------------}


end.
