unit Arrays;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Numbers, StdCtrls;

type
  TArrayInt = array of integer;

procedure arrayCompress(var arr: TArrayInt; ranges: TArrayRanges; var compressed: integer);
procedure arrayPrint(arr: TArrayInt; var memo: TMemo);
procedure arrayPush(var arr: TArrayInt; el: integer);
procedure arrayRemove(var arr: TArrayInt; el: integer);
function arraySearch(arr: TArrayInt; First: boolean): integer;
procedure arraySort(var arr: TArrayInt);

implementation

{Процедура компресии массива по заданным отрезкам}
procedure arrayCompress(var arr: TArrayInt; ranges: TArrayRanges; var compressed: integer);
var
  i, j, k: integer;
begin
  if (Length(arr) > 0) and (Length(ranges) > 0) then
  begin
    for i := High(arr) downto Low(arr) do
    begin
      if (inRange(arr[i], ranges)) then
      begin
        arrayRemove(arr, i);
        Inc(compressed);
      end;
    end;
  end;
end;


{Процедура вывода массива в Memo}
procedure arrayPrint(arr: TArrayInt; var memo: TMemo);
var
  i: integer;
begin
  memo.Clear;

  if (Length(arr) > 0) then
  begin
    for i := Low(arr) to High(arr) do
    begin
      memo.Lines[i] := IntToStr(arr[i]);
    end;

    memo.Text := Trim(memo.Text);
  end;
end;


{Процедура для добавления нового элемента в массив целочисленных значений}
procedure arrayPush(var arr: TArrayInt; el: integer);
var
  newLength: integer;
begin
  newLength := Length(arr) + 1;
  SetLength(arr, newLength);
  arr[High(arr)] := el;
end;


{Процедура удаления элемента из массива}
procedure arrayRemove(var arr: TArrayInt; el: integer);
var
  i: integer;
begin
  if (el >= Low(arr)) or (el <= high(arr)) then
  begin
    for i := el to High(arr) - 1 do
    begin
      arr[i] := arr[i + 1];
    end;
    SetLength(arr, Length(arr) - 1);
  end;
end;


{Функция поиска максимального значения}
{arr - массив, по которому ищем, first - тип поиска, если истина - вернет первое
максимальное значение}
function arraySearch(arr: TArrayInt; First: boolean): integer;
var
  i, i_max: integer;
begin
  if (Length(arr) > 0) then
  begin
    i_max := Low(arr);
    for i := Low(arr) to High(arr) do
    begin
      if (First) and (arr[i] > arr[i_max]) or (not First) and
        (arr[i] >= arr[i_max]) then
      begin
        i_max := i;
      end;

      Result := i_max;
    end;
  end
  else
  begin
    Result := -1;
  end;
end;

{Процедура сортировки массива методом прямого выбора}
procedure arraySort(var arr: TArrayInt);
var
  // номер минимального элемента в части массива от i до верхней границы массива
  min: integer;
  // номер элемента, сравниваемого с минимальным
  j: integer;
  // буфер, используемый при обмене элементов массива
  buf: integer;
  i: integer;
begin

  for i := Low(arr) to High(arr) do
  begin
    { поиск минимального элемента в массиве}
    min := i;
    for j := i + 1 to High(arr) do
      if arr[j] < arr[min] then
        min := j;

    { поменяем местами a [min] и a[i] }
    buf := arr[i];
    arr[i] := arr[min];
    arr[min] := buf;
  end;
end;

end.
