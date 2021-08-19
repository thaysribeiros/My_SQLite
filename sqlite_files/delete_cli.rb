=begin
==========================
        DELETE CLI
==========================
valid_delete
    - validates delete query 
    - validates params of delete query
        - if valid THEN
            - requests delete queries
        - else 
            - prints error message
=end

module DeleteCli

    def _seq_validator
        if @delete_idx == 0 and @from_idx == 1
            return true
        end
        return false
    end

    def _set_idx_(key, idx)
        if key == "DELETE"
            @delete_idx = idx
        elsif key == "FROM"
            @from_idx = idx
        elsif key == "WHERE"
            @where_idx = idx
        end
    end

    def validate_delete_query(result)
        result.each_with_index do |(key, val), idx|
            if @delete_cmds.include?(key)
                _set_idx_(key, idx)
            else
                return "INVALID: Query should only contain DELETE, FROM, WHERE"
            end
        end
        if _seq_validator == true
            return true
        else
            return "INVALID: Query order should be: DELETE => FROM => WHERE"
        end
    end

    def _if_delete(arr, idx, request)
        if arr[idx + 1] and arr[idx + 1] != "FROM" and arr[idx + 2] and is_param_not_cmd(arr[idx + 2]) != true
            return "INVALID: DELETE should follow by FROM"
        else
            request.delete
            return true
        end
    end

    def validate_delete_query_param(arr, request)
        arr.each_with_index do |element, idx|
            if element.upcase == "DELETE"
                ret = _if_delete(arr, idx, request)
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
            end
        end
        return true
    end

    def valid_delete(result, arr, request)
        query_ret_val = validate_delete_query(result)
        if query_ret_val == true
            param_ret = validate_delete_query_param(arr, request)
            if param_ret == true
                request.run
                p "Table or row is deleted"
            else
                p param_ret
            end
        else
            p query_ret_val
        end
    end
end
