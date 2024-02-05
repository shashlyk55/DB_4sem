-- ���������� ������, �������� ������� ������ ������������� ����� ��������� ����;
SELECT        Product_name, Delivery_date
FROM            ������
WHERE        (CONVERT(DATETIME, '2024-06-01 00:00:00', 102) <= Delivery_date)

-- ����� ������, ���� ������� ��������� � ��������� ��������;
SELECT        Name, Price
FROM            ������
WHERE        (Price >= 100 AND Price <= 250)

-- ���������� �������� ����, ���������� ���������� �����;
SELECT        Client
FROM            ������
WHERE        (Product_name = N'��������' or Product_name = N'�������')

-- ����� ������ ������������ ����� �� �� ��������, ������������� �� �� ����� ��������.
SELECT        ������.*
FROM            ������
WHERE        (Client IN (N'EPAM','LeverX'))
ORDER BY Delivery_date

SELECT        ������.*
FROM            ������
WHERE        (Client IN (N'LeverX', N'ITechArt'))
ORDER BY Delivery_date DESC