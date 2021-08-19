=begin
==========================
        INSERT CLI
==========================
valid_insert
    - validates insert query 
    - validates params of insert query
        - if valid THEN
            - requests insert queries
        - else 
            - prints error message
=end

module InsertCli

    def _seq_validator_insert
        if @insert_idx == 0 and @into_idx == 1 and @values_idx == 2
            return true
        end
        return false
    end

    def _set_idx_insert(key, idx)
        if key == "INSERT"
            @insert_idx = idx
        elsif key == "INTO"
            @into_idx = idx
        elsif key == "VALUES"
            @values_idx = idx
        end
    end

    def validate_insert_query(result)
        result.each_with_index do |(key, val), idx|
            if @insert_cmds.include?(key) == true
                _set_idx_insert(key, idx)
            else
                return "INVALID: Query should only contain INSERT INTO, VALUES"
            end
        end
        if _seq_validator_insert == true
            return true
        else
            return "INVALID: Query order should be: INSERT INTO => VALUES"
        end
    end

    def _if_insert(arr, idx, request)
        if is_param_not_cmd(arr[idx + 2]) != true or arr[idx + 3] != "VALUES"
            return "INVALID: Table name not passed after INSERT OR VALUES is not passed after column"
        else
            request.insert(arr[idx + 2])
            return true
        end
    end

    def _if_insert(arr, idx, request)
        if is_param_not_cmd(arr[idx + 2]) != true or arr[idx + 3] != "VALUES"
            return "INVALID: Table name not passed after INSERT OR VALUES is not passed after column"
        else
            request.insert(arr[idx + 2])
            return true
        end
    end
    
    def _set_hash(val, result, request)
        idx = 0
        headers = request._get_header
        while idx < val.length
            if val[idx]
                result[headers[idx]] = val[idx]
            else
                return "Invalid index in VALUES"
            end
            idx += 1
        end
        request.values(result)
        return true
    end

    def get_hash(arr, idx, before_hash, request, result)
        val = []
        while idx < arr.length - 1
            arr[idx + 1].gsub!("(", "")
            arr[idx + 1].gsub!(",", "")
            arr[idx + 1].gsub!(")", "")
            arr[idx + 1].gsub!(";", "")
            val << arr[idx + 1]
            idx += 1
        end
        return _set_hash(val, result, request)
    end

    def _if_values(arr, idx, request)
        result = {}
        before_hash = []
        if @values_idx != 0
            return get_hash(arr, idx, before_hash, request, result)
        end
    end

    def validate_insert_query_param(arr, request)
        arr.each_with_index do |element, idx|
            if element.upcase == "INSERT"
                ret = _if_insert(arr, idx, request)
                if ret != true
                    return ret
                end
            elsif element.upcase == "VALUES"
                ret = _if_values(arr, idx, request)
                if ret != true
                    return ret
                end
            end
        end
        return true
    end

    def valid_insert(result, arr, request)
        query_ret_val = validate_insert_query(result)
        if query_ret_val == true
            param_ret = validate_insert_query_param(arr, request)
            if param_ret == true
                request.run
                p "A row is inserted"
            else
                p param_ret
            end
        else
            p query_ret_val
        end
    end
end
