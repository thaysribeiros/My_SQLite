module Insert

    #==========
    # SQL CMD
    #==========    
    
    def insert(table_name)
        @type_of_query = :insert
        @table_name = table_name
    end

    # @param {hash key value}
    def values(data)
        if (@type_of_query == :insert)
            @insert_vals = data
        else
            raise "VALUES must correspond with INSERT Query"
        end
    end
    
    #==========
    #  PRINT
    #==========
    
    def _print_insert
        puts "INSERT INTO #{@table_name} "
        puts "VALUES #{@insert_vals} "
        # if (@where_col)
        #     puts "WHERE #{@where_col} = #{@where_col_val}"
        # end
    end

    #=============
    # EXEC INSERT
    #=============

    def _exec_insert
        File.open(@table_name, 'a') do |file|
            file.puts @insert_vals.values.join(',')
        end
    end

    #==========
    # HELPER
    #==========

    def _get_header
        csv = CSV.read(@table_name, headers:true)
        return csv.headers
    end
end
