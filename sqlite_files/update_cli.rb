=begin
==========================
        UPDATE CLI
==========================
valid_update
    - validates update query 
    - validates params of update query
        - if valid THEN
            - requests update queries
        - else 
            - prints error message
=end
module UpdateCli

    def _seq_validator_update
        if @update_idx == 0 and @set_idx == 1
            return true
        end
        return false
    end

    def _set_idx_update(key, idx)
        if key == "UPDATE"
            @update_idx = idx
        elsif key == "SET"
            @set_idx = idx
        elsif key == "WHERE"
            @where_idx = idx
        end
    end

    def validate_update_query(result)
        result.each_with_index do |(key, val), idx|
            if @update_cmds.include?(key)
                _set_idx_update(key, idx)
            else
                return "INVALID: Query should only contain UPDATE, SET, WHERE"
            end
        end
        if _seq_validator_update == true
            return true
        else
            return "INVALID: Update query order should be: UPDATE => SET"
        end
    end

    def _if_update(arr, idx, request)
        if is_param_not_cmd(arr[idx + 1]) != true or arr[idx + 2] != "SET"
            return "INVALID: Table name not passed after UPDATE OR SET is not passed"
        else
            request.update(arr[idx + 1])
            return true
        end
    end
    def _set_hash_updt(before_hash, result, request)
        idx = 0
        while idx < before_hash.length
            if before_hash[idx + 1]
                result[before_hash[idx]] = before_hash[idx + 1].split("'")[1]
            else
                return "INVALID: SET col and criteria are not passed."
            end
            idx += 2
        end
        request.set(result)
        return true
    end

    def _when_where_updt(arr, idx, before_hash, request, result)
        while arr[idx + 1] != "WHERE"
            if arr[idx + 1] and arr[idx + 1] != "="
                before_hash << arr[idx + 1]
            end
            idx += 1
        end
        return _set_hash_updt(before_hash, result, request)
    end

    def _no_where_updt(arr, idx, before_hash, request, result)
        i = idx 
        while i < arr.length - 1
            if arr[i + 1] and arr[i + 1] != "="
                before_hash << arr[i + 1]
            end
            i += 1
        end
        return _set_hash_updt(before_hash, result, request)
    end

    def _if_set(arr, idx, request)
        result = {}
        before_hash = []
        if @where_idx != 0
            return _when_where_updt(arr, idx, before_hash, request, result)
        else
            return _no_where_updt(arr, idx, before_hash, request, result)
        end
    end
    
    def validate_update_query_param(arr, request)
        arr.each_with_index do |element, idx|
            if element.upcase == "UPDATE"
                ret = _if_update(arr, idx, request)
                if ret != true
                    return ret
                end
            elsif element.upcase == "SET"
                ret = _if_set(arr, idx, request)
                if ret != true
                    return ret
                end
            elsif element.upcase == "WHERE"
                ret = _if_where(arr, idx, request)
                if ret != true
                    return ret
                end
            end
        end
        return true
    end

    def valid_update(result, arr, request)
        query_ret_val = validate_update_query(result)
        if query_ret_val == true
            param_ret = validate_update_query_param(arr, request)
            if param_ret == true
                request.run
                p "Table or row is updated"
            else
                p param_ret
            end
        else
            p query_ret_val
        end
            
    end
end
