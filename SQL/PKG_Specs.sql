create or replace package pkg_finance_manager is

    procedure prc_generate_installments(p_contract_id in number);
    
    procedure prc_generate_all_pending;
end;
