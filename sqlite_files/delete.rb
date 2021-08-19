=begin
======================
        DELETE
======================
_exec_delete
    - opens a file 
    - either deletes a row
    - or deletes entire file
=end

module Delete
    #====================
    # SQL CMD
    # setting query type
    #====================

    def delete 
        @type_of_query = :delete
    end
    
    #==========
    #  PRINT
    #==========
    
    def _print_delete
        puts "DELETE FROM #{@table_name}"
        if (@where_col)
            puts "WHERE #{@where_col} = #{@where_col_val}"
        end
    end
    
    #=============
    # EXEC DELETE
    #=============

    def _exec_delete
        csv = CSV.read(@table_name, headers:true)
        csv.delete_if do |row|
            !@where_col and !@where_col_val
        end
        csv.delete_if do |row|
            @where_col and @where_col_val and (row[@where_col] == @where_col_val)
        end
        _updating_file(csv)
    end  
end
