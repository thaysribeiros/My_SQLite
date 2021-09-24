=begin
==========================
        SELECT CLI
==========================
valid_select
    - validates SELECT query 
    - validates params of SELECT query
        - if valid THEN
            - requests SELECT queries
        - else 
            - prints error message
=end

module SelectCli
    #===================================
    # validate_select_query_params funcs
    #===================================

    #==============
    # SELECT PARSE
    #==============    

    def _star_parse(arr, idx, request)
        if !is_param_not_cmd(arr[idx + 2]) and arr[idx + 2] == "FROM"
            request.select("*")
            return true
        else
            return "INVALID => SELECT * should be followed by a FROM query"
        end
    end

    def _col_arr(arr, idx, request)
        select_col = arr[idx + 1].split(",")
        if select_col[2] != nil and select_col[0] == "*" or 
            (is_param_not_cmd(select_col[0]) and 
            is_param_not_cmd(arr[idx + 2]) and 
            is_param_not_cmd(arr[idx + 3]))
            return "INVALID => SELECT accepts up to two columns"
        else
            if select_col[1] == nil
                request.select([select_col[0], arr[idx + 2]])
            else
                request.select([select_col[0], select_col[1]])
            end
            return true
        end
    end

    def _reg_col(arr, idx, request)
        if arr[idx + 2] == nil or !is_param_not_cmd(arr[idx + 3])
            return "INVALID => SELECT columns cannot be nil OR FROM is missing OR table is missing after FROM"
        end
        if is_param_not_cmd(arr[idx + 1])
            request.select(arr[idx + 1])
            return true
        else
            return "INVALID => SELECT cannot be followed by another SQL command"
        end
    end

    def _if_select(arr, idx, request)
        if is_param_not_cmd(arr[idx + 1]) and arr[idx + 1] == "*"
            ret = _star_parse(arr, idx, request)
            if ret == true
                return true
            else
                return ret
            end
        elsif is_param_not_cmd(arr[idx + 1]) and arr[idx + 1].include?(",")
            ret = _col_arr(arr, idx, request)
            if ret == true
                return true
            else
                return ret
            end
        else
            ret = _reg_col(arr, idx, request) 
            if ret == true
                return true
            else
                return ret
            end
        end
    end

    #==============
    # FROM PARSE
    #==============   

    def _if_from(arr, idx, request)
        if is_param_not_cmd(arr[idx + 1])
            request.from(arr[idx + 1])
            return true
        else
            return "INVALID => FROM is missing a table name"
        end
    end
    
    #==============
    # WHERE PARSE
    #==============   

    def _missing_col(arr, idx)
        if !is_param_not_cmd(arr[idx + 1]) or 
            !is_param_not_cmd(arr[idx + 2]) or 
            !is_param_not_cmd(arr[idx + 3]) or 
            !arr[idx + 3].include?("'")
            return true
        end
    end
    
    def _if_quote(arr, idx, request)
        x = 3
        counter = 0
        where_val = []
        while x < arr.length
            if arr[idx + x] and arr[idx + x].include?("'")
                arr[idx + x].gsub!("'","")
                arr[idx + x].gsub!(";","")
                where_val << arr[idx + x]
            elsif arr[idx + x]
                where_val << arr[idx + x]
            end
            x += 1
        end 
        request.where(arr[idx + 1], where_val.join(" "))
        return true
    end

    def _if_where(arr, idx, request)
        if arr[idx + 1] != nil and arr[idx + 1].include?("=")
            return "INVALID => Space required between where column and its value"
        else
            if _missing_col(arr, idx) == true
                return "INVALID => WHERE col and values are missing OR values are missing single quotes"
            else
                return _if_quote(arr, idx, request)
            end
        end
    end

    #==============
    # JOIN PARSE
    #==============  

    def _if_join(arr, idx, request)
        if is_param_not_cmd(arr[idx + 1]) and is_param_not_cmd(arr[idx + 2]) and arr[idx + 2] == "ON"
            if is_param_not_cmd(arr[idx + 3]) and arr[idx + 3].include?("=")
                join_col = arr[idx + 3].split("=")
                if !is_param_not_cmd(join_col[0]) or !is_param_not_cmd(join_col[1]) 
                    return "INVALID => JOIN is missing table columns"
                else
                    request.join(join_col[0], arr[idx + 1], join_col[1])
                    return true
                end
            elsif is_param_not_cmd(arr[idx + 3]) and is_param_not_cmd(arr[idx + 4]) and 
                arr[idx + 4] == "=" and is_param_not_cmd(arr[idx + 5])
                request.join(arr[idx + 3], arr[idx + 1], arr[idx + 5])
                return true
            else
                return "INVALID => JOIN ON does not include a compare operator OR missing comparing tables"
            end
        else
            return "INVALID => JOIN is missing a table column OR missing ON command"
        end
    end

    #==============
    # ORDER PARSE
    #==============  

    def _if_order(arr, idx, request)
        if is_param_not_cmd(arr[idx + 1]) and is_param_not_cmd(arr[idx + 2]) and arr[idx + 2] == "BY"
            if is_param_not_cmd(arr[idx + 3]) and 
                (arr[idx + 3].upcase == "ASC" or 
                arr[idx + 3].upcase == "DESC")
                request.order(arr[idx + 3], arr[idx + 1])
                return true
            else
                return "INVALID => ORDER BY should be ASC or DESC"
            end
        else
            return "INVALID => ORDER is missing a table column OR missing BY command"
        end #if_end
    end #_if_order

    def validate_select_query_params(arr, request)
        res = []
        arr.each_with_index do |element, idx|
            if element.upcase == "SELECT"
                ret = _if_select(arr, idx, request)
                if ret != true
                    return ret
                end
            elsif element.upcase == "FROM"
                ret = _if_from(arr, idx, request)
                if ret != true
                    return ret
                end
            elsif element.upcase == "WHERE"
                ret = _if_where(arr, idx, request)
                if ret != true
                    return ret
                end
            elsif element.upcase == "JOIN"
                ret = _if_join(arr, idx, request)
                if ret != true
                    return ret
                end
            elsif element.upcase == "ORDER"
                ret = _if_order(arr, idx, request)
                if ret != true
                    return ret
                end
            end
        end
        return true
    end

    #=============================
    # validate_select_query funcs
    #=============================
    
    def _where_order_join_valid(flag)
        if @where_idx != 0 and @join_idx != 0 and @where_idx < @join_idx
            flag = false
        elsif @order_idx != 0 and @where_idx != 0 and @order_idx < @where_idx
            flag = false
        elsif @order_idx != 0 and @join_idx != 0 and @order_idx < @join_idx
            flag = false
        end
        return flag
    end

    def _get_idx_order_join_wh(key, idx)
        if key == "ORDER"
            @order_idx = idx
        elsif key == "JOIN"
            @join_idx = idx
        elsif key == "WHERE"
            @where_idx = idx
        end
    end

    def validate_select_query(result)
        flag = false
        counter = 0
        idx_arr = []
        
        result.each_with_index do |(key, val), idx|
            if @valid_hash_select[key].kind_of?(Array)
                @valid_hash_select[key].each do |value|
                    if value == idx
                        counter += 1
                    end
                    _get_idx_order_join_wh(key, idx)
                end
            else
                if @valid_hash_select[key] == idx 
                    counter += 1
                    flag = true
                end
            end
        end
        if counter == result.length
            flag = true
            flag = _where_order_join_valid(flag)
        else
            flag = false
        end
        return flag
    end
    
    #===============================
    # Entry point for Select module
    #===============================
    
    def valid_select(result, arr, request)
        if validate_select_query(result)
            val_result = validate_select_query_params(arr, request)
            if val_result == true
                request.run
            else
                p val_result
            end    
        else
        p "Invalid Order"    
        end
    end
end
