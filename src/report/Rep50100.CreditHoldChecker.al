report 50100 "Credit Hold Checker"
{
    Caption = 'Credit Hold Checker';
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Order));
            trigger OnPreDataItem()
            var
                CreditHoldRec: Record "Credit Hold Orders";
                // UniqueCustomer: Code[20];
                Cust: Record Customer;
                SalesHeader2: Record "Sales Header";
                CurrDate: Date;
            begin
                CreditHoldRec.SetCurrentKey("Sell-to Customer No.");
                CreditHoldRec.FindSet();
                repeat
                    Cust.Get(CreditHoldRec."Sell-to Customer No.");
                    Cust.CalcFields("Balance (LCY)");

                    if (Cust."Balance (LCY)" <= Cust."Credit Limit (LCY)") or (Cust."Credit Limit (LCY)" = 0) then begin
                        SalesHeader2.SetRange("Sell-to Customer No.", CreditHoldRec."Sell-to Customer No.");
                        SalesHeader2.SetRange("Credit Hold", true);
                        SalesHeader2.ModifyAll("Credit Hold", false);
                    end;
                until CreditHoldRec.Next() = 0;





                CurrDate := Today();
                if CustomerNo <> '' then
                    SetRange("Sell-to Customer No.", CustomerNo);




                if (FromDate <> 0D) and (ToDate <> 0D) then begin
                    if FromDate > ToDate then
                        Error('From Date cannot be greater than To Date.');

                    SetRange("Document Date", FromDate, ToDate);
                end else
                    if (FromDate = 0D) and (ToDate <> 0D) then
                        SetRange("Document Date", 0D, ToDate)
                    else
                        if (FromDate <> 0D) and (ToDate = 0D) then
                            SetRange("Document Date", FromDate, CurrDate);


            end;






            trigger OnAfterGetRecord()
            var
                Cust: Record Customer;
                CreditHoldRec: Record "Credit Hold Orders";
                SalesHeader2: Record "Sales Header";
            begin
                Cust.Reset();
                Cust.SetRange("No.", SalesHeader."Sell-to Customer No.");

                if Cust.FindFirst() then begin
                    Cust.CalcFields("Balance (LCY)");
                    if (Cust."Balance (LCY)" > Cust."Credit Limit (LCY)") and
   (Cust."Credit Limit (LCY)" <> 0) then begin

                        CreditHoldRec.Reset();
                        CreditHoldRec.SetRange("Order No.", SalesHeader."No.");
                        if CreditHoldRec.FindFirst() then begin
                            // Update existing record
                            CreditHoldRec."Document Type" := Format(SalesHeader."Document Type");
                            CreditHoldRec."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                            CreditHoldRec."Sell-to Customer Name" := SalesHeader."Sell-to Customer Name";
                            CreditHoldRec."External Document No." := SalesHeader."External Document No.";
                            CreditHoldRec."Location Code" := SalesHeader."Location Code";
                            CreditHoldRec."Status" := Format(SalesHeader."Status");
                            CreditHoldRec."Shipment Date" := SalesHeader."Shipment Date";
                            SalesHeader.CalcFields(Amount);
                            CreditHoldRec."Amount" := SalesHeader.Amount;
                            SalesHeader.CalcFields("Amount Including VAT");
                            CreditHoldRec."Amount Including VAT" := SalesHeader."Amount Including VAT";
                            CreditHoldRec.Modify();
                        end else begin
                            // Insert new record
                            CreditHoldRec.Init();
                            CreditHoldRec."Order No." := SalesHeader."No.";
                            CreditHoldRec."Document Type" := Format(SalesHeader."Document Type");
                            CreditHoldRec."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                            CreditHoldRec."Sell-to Customer Name" := SalesHeader."Sell-to Customer Name";
                            CreditHoldRec."External Document No." := SalesHeader."External Document No.";
                            CreditHoldRec."Location Code" := SalesHeader."Location Code";
                            CreditHoldRec."Status" := Format(SalesHeader."Status");
                            CreditHoldRec."Shipment Date" := SalesHeader."Shipment Date";
                            SalesHeader.CalcFields(Amount);
                            CreditHoldRec."Amount" := SalesHeader.Amount;
                            SalesHeader.CalcFields("Amount Including VAT");
                            CreditHoldRec."Amount Including VAT" := SalesHeader."Amount Including VAT";
                            CreditHoldRec.Insert();
                        end;

                    end;
                    SalesHeader2.Get(SalesHeader."Document Type", SalesHeader."No.");
                    SalesHeader2."Credit Hold" := true;
                    SalesHeader2.Modify(true);

                end;

            end;

        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group("Credit Check Filters")
                {
                    field(CustomerNo; CustomerNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer No.';
                        TableRelation = Customer."No.";
                    }
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                    }
                }
            }
        }
    }

    var
        FromDate: Date;
        ToDate: Date;
        CustomerNo: Code[20];
        creditTable: Record "Credit Hold Orders";

    trigger OnPostReport()
    begin

        Page.Run(50505);
    end;
}



