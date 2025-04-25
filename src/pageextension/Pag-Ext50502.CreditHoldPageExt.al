pageextension 50502 CreditHoldPageExt extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Credit Hold"; Rec."Credit Hold")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}