table 50500 "Credit Hold Orders"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Order No."; Code[20]) { DataClassification = CustomerContent; }
        field(3; "Document Type"; Code[30]) { }
        field(4; "Sell-to Customer No."; Code[20]) { }
        field(5; "Sell-to Customer Name"; Text[100]) { }
        field(6; "External Document No."; Code[35]) { }
        field(7; "Location Code"; Code[10]) { }
        field(8; "Status"; text[30])
        {
        }
        field(9; "Shipment Date"; Date) { }
        field(10; "Amount"; Decimal) { }
        field(11; "Amount Including VAT"; Decimal) { }
        field(12; "view Doc"; code[30]) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
