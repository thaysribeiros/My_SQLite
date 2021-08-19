module Update
    #==========
    # SQL CMD
    #==========

    def update(table_name)
        @type_of_query = :update
        @table_name = table_name
    end

    def set(data) 
        if (@type_of_query == :update)
            @update_vals = data
        else
            raise "SET must correspond with UPDATE Query"
        end
    end

    #==========
    #  PRINT
    #==========

    def _print_update
        puts "UPDATE #{@table_name} "
        puts "SET #{@update_vals} "
        if (@where_col)
            puts "WHERE #{@where_col} = #{@where_col_val}"
        end
    end

    #=============
    # EXEC UPDATE
    #=============

    def _exec_update
        csv = CSV.read(@table_name, headers:true)
        csv.each do |row|
            if @where_col and @where_col_val and (row[@where_col] == @where_col_val)
                @update_vals.each do |key, value|
                    row[key] = value
                end
            elsif !@where_col or !@where_col_val
                @update_vals.each do |key, value|
                    row[key] = value
                end
            end
        end
        _updating_file(csv)
    end

    #==========
    # HELPER
    #==========

    def _updating_file(csv)
        File.open(@table_name, 'w+') do |file|
            idx = 0
            csv.each do |row|
                if idx == 0
                    file << csv.headers.join(',') + "\n"
                end
                file << row
                idx += 1
            end
        end
    end
    
    
end
