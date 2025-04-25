tableextension 50501 HoldCustomeFiled extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50501; "Credit Hold"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}