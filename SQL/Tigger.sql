create or replace trigger trg_after_insert_contract
for insert on contracts
compound trigger

    type t_contract_ids is table of contracts.contract_id%type;
    v_ids t_contract_ids := t_contract_ids();

    after each row is
    begin
        v_ids.extend;
        v_ids(v_ids.last) := :new.contract_id;
    end after each row;

    after statement is
    begin
        for i in 1 .. v_ids.count loop
            pkg_finance_manager.prc_generate_installments(v_ids(i));
        end loop;
    end after statement;

end;



insert into contracts (contract_id, contract_startdate, contract_enddate, contract_total_fees, contract_deposit_fees, client_id, contract_payment_type)
values (107, date '2024-01-01', date '2025-01-01', 120000, 0, 1, 'monthly');
