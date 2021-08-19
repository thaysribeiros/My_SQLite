module Select

    #==========
    # SQL CMD
    #==========

    def select(query_col)
        @type_of_query = :select
        if (query_col.kind_of?(Array))
            # if query_col is an array
            @columns += query_col.map { |col| col.to_s} 
        else
            @columns << query_col.to_s # if not an array
        end
    end
    
    def join(col_on_db_a, file_db_b, col_on_db_b)
        @join_flag = 1
        @column_join_db_a = col_on_db_a
        @second_db = file_db_b
        @column_join_db_b = col_on_db_b
    end
    
    def order(order, column_name)
        @order_flag = 1
        @order_type = order
        @order_col = column_name
    end
    
    #==========
    #  PRINT
    #==========

    def _print_select
        puts "SELECT #{@columns} "
        puts "FROM #{@table_name} "
        if (@where_col)
            puts "WHERE #{@where_col} = #{@where_col_val}"
        end
        if (@column_join_db_a and @column_join_db_b and @second_db)
            puts "JOIN #{@second_db} ON #{@table_name}.#{@column_join_db_a}=#{@second_db}.#{@column_join_db_b}"
        end
        if (@order_col and (@order_type.upcase == "DESC" || @order_type.upcase == "ASC") )
            puts "ORDER BY #{@order_col} #{@order_type}"
        end
    end
    
    #==========
    # CHECKERS
    #==========

    def check_matching_cols(row, row_b, result)
        first_col =  @columns[0]
        second_col = @columns[1]
        if (row[@column_join_db_a] == row_b[@column_join_db_b]) and (row[@where_col] == @where_col_val)
            result << {first_col => row[first_col], second_col => row_b[second_col]}
        elsif (!@where_col or !@where_col_val) and (row[@column_join_db_a] == row_b[@column_join_db_b])
            result << {first_col => row[first_col], second_col => row_b[second_col]}
        end
    end
    
    def _check_invalid_cols(row, row_b)
        if !row[@column_join_db_a] or 
            !row_b[@column_join_db_b] or 
            !row.has_key?(@columns[0]) or 
            !row_b.has_key?(@columns[1]) or
            !row.has_key?(@where_col)
            return true
        end
    end

    #==========
    #  PARSE
    #==========

    def _parse_order(result)
        if (@order_col and @order_type.upcase == "DESC")
            result = result.sort_by!{ |h| h[@order_col] }.reverse!
        elsif (@order_col and @order_type.upcase == "ASC")
            result = result.sort_by{ |h| h[@order_col] }
        # else
        #     result = result.sort_by { |element| element.values }
        end
        return result
    end

    def _parse_when_join(result, csv)
        csv_b = CSV.parse(File.read(@second_db), headers: true)
        csv.each do |row|
            csv_b.each do |row_b|
                if _check_invalid_cols(row, row_b)
                    throw "Column doesn't exist in the database"
                end
                check_matching_cols(row, row_b, result)
            end
        end
    end
    

    def _parse_when_not_join(result, csv)
        csv.each do |row|
            if row[@where_col] == @where_col_val and @where_col and @where_col_val #where is present
                if @columns[0] == "*"
                    result << row.to_hash
                else
                    # p row[*@columns]
                    result << row.to_hash.slice(*@columns)
                end
            elsif !@where_col or !@where_col_val
                if @columns[0] == "*"
                    result << row.to_hash
                elsif @columns[0] != "*"
                    result << row.to_hash.slice(*@columns)
                end
            end
        end
    end

    #===========
    #EXEC SELECT
    #===========

    def _exec_select
        result = []
        csv = CSV.parse(File.read(@table_name), headers: true)
        if @join_flag != 1
            _parse_when_not_join(result, csv)
        else
            _parse_when_join(result, csv)
        end
        if @order_flag == 1
            result = _parse_order(result)
        end
        result
    end
end
