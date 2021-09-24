class MySqliteRequest
    include Select
    include Update
    include Insert
    include Delete
    
    def initialize
        @type_of_query = :none
        @table_name = nil
        @columns = []
        @order_type = :asc
        @where_col = nil
        @where_col_val = nil
        @order_col = nil
        @insert_vals = {}
        @update_vals = {}
        @column_join_db_a = nil
        @second_db = nil
        @column_join_db_b = nil
        @join_flag = 0
        @order_flag = 0
        @where_flag = 0
    end

    def reset
        initialize
    end

    def _parser
        if (@type_of_query == :select)
            _print_select
            _exec_select            
        elsif(@type_of_query == :insert)
            _print_insert
            _exec_insert  
        elsif(@type_of_query == :update)
            _print_update
            _exec_update
        elsif(@type_of_query == :delete)
            _print_delete
            _exec_delete
        end
    end

    def from(table_name)
        @table_name = table_name
    end

    def where(column_name, criteria)
        if (@where_flag == 0)
            @where_col = column_name
            @where_col_val = criteria
            @where_flag = 1
        elsif (@where_flag == 1)
            @where_col_1 = column_name
            @where_col_val_1 = criteria
        else
            raise "Error: too many where clauses"
        end
    end

    def run
        _parser
    end
end
