create or replace package body pkg_finance_manager is

    function fn_get_months_interval(p_payment_type in varchar2) return number is
    begin
        return case p_payment_type
            when 'monthly'     then 1
            when 'quarter'     then 3
            when 'half_annual' then 6
            when 'annual'      then 12
            else 1
        end;
    end;

    function fn_calculate_installment_count(
        p_start_date in date, 
        p_end_date   in date, 
        p_interval   in number
    ) return number is
        v_total_months number;
    begin
        v_total_months := months_between(p_end_date, p_start_date);
        return floor(v_total_months / p_interval);
    end;

    function fn_calculate_amount_per_period(
        p_total   in number, 
        p_deposit in number, 
        p_count   in number
    ) return number is
    begin
        return (p_total - nvl(p_deposit, 0)) / p_count;
    end;

    function fn_is_contract_processed(p_contract_id in number) return boolean is
        v_count number;
    begin
        select count(*) into v_count 
        from installments 
        where contract_id = p_contract_id;
        
        return v_count > 0;
    end;

    procedure prc_generate_installments(p_contract_id in number) is
        v_contract_rec     contracts%rowtype;
        v_interval         number;
        v_inst_count       number;
        v_amount_per_inst  number;
        v_inst_date        date;
        v_next_id          number;
    begin
        if fn_is_contract_processed(p_contract_id) then
            dbms_output.put_line('contract ' || p_contract_id || ' is already processed.');
            return;
        end if;

        select * into v_contract_rec 
        from contracts 
        where contract_id = p_contract_id;

        v_interval        := fn_get_months_interval(lower(v_contract_rec.contract_payment_type));
        v_inst_count      := fn_calculate_installment_count(v_contract_rec.contract_startdate, v_contract_rec.contract_enddate, v_interval);
        v_amount_per_inst := fn_calculate_amount_per_period(v_contract_rec.contract_total_fees, v_contract_rec.contract_deposit_fees, v_inst_count);
        
        v_inst_date := v_contract_rec.contract_startdate;

        for i in 1..v_inst_count loop
            select nvl(max(installment_id), 0) + 1 into v_next_id from installments;

            insert into installments (installment_id, contract_id, installment_date, installment_amount)
            values (v_next_id, p_contract_id, v_inst_date, v_amount_per_inst);

            v_inst_date := add_months(v_inst_date, v_interval);
        end loop;
        
        dbms_output.put_line('installments generated for contract: ' || p_contract_id);
    end;

    procedure prc_generate_all_pending is
    begin
        for rec in (select contract_id from contracts) loop
            prc_generate_installments(rec.contract_id);
        end loop;
    end;

end;