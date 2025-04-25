page 50505 CreditHoldPage
{
    PageType = List;
    SourceTable = "Credit Hold Orders";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Order No."; Rec."Order No.") { ApplicationArea = All; }
                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.") { ApplicationArea = All; }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name") { ApplicationArea = All; }
                field("External Document No."; Rec."External Document No.") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field("Status"; Rec."Status") { ApplicationArea = All; }
                field("Shipment Date"; Rec."Shipment Date") { ApplicationArea = All; }
                field("Amount"; Rec."Amount") { ApplicationArea = All; }
                field("Amount Including VAT"; Rec."Amount Including VAT") { ApplicationArea = All; }
                field("view Doc"; Rec."view Doc")
                {
                    ApplicationArea = all;
                    Caption = 'View Document';

                    trigger OnAssistEdit()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Order No.") then
                            Page.Run(Page::"Sales Order", SalesHeader);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateReport)
            {
                Caption = 'Generate Credit Hold Report';
                ApplicationArea = All;
                Image = Report;
                trigger OnAction()
                begin
                    Report.RunModal(50100, true, true);
                end;
            }
        }
    }
}

