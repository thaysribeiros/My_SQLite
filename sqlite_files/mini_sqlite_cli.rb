require_relative 'update_cli'
require_relative 'insert_cli'
require_relative 'delete_cli'

class SqliteCli
    include UpdateCli
    include SelectCli
    include InsertCli
    include DeleteCli
    
    def initialize
        @order_idx = 0
        @where_idx = 0
        @join_idx = 0
        @update_idx = 0
        @set_idx = 0
        @into_idx = 0
        @insert_idx = 0
        @values_idx = 0
        @from_idx = 0
        @delete_idx = 0
        @valid_hash_select = {
            "SELECT" => 0, 
            "*"      => 1,
            "FROM"   => [1, 2], 
            "WHERE"  => [2, 3, 4],
            "JOIN"   => [2, 3],
            "ORDER"  => [2, 3, 4, 5],
        }
        @all_sql_cmd = ["SELECT", "UPDATE", "INSERT", "DELETE", "FROM", "WHERE", "JOIN", "ORDER", "SET", "VALUES", "INTO"]
        @update_cmds = ["UPDATE", "SET", "WHERE"]
        @insert_cmds = ["INSERT", "INTO", "VALUES"]
        @delete_cmds = ["DELETE", "FROM", "WHERE"]
    end
    
    #==============
    # SQL_CLI FUNCS
    #==============
    
    def no_recur(input_arr)
        result = {}
        idx = 0
        flag = 0
        input_arr.each_with_index do |element, idx|
            if @all_sql_cmd.include?(element.upcase)
                
                if result[element.upcase]
                    result[element.upcase] += 1
                else
                    result[element.upcase] = 1
                end
            end
        end
        
        result.each do |key,value|
            if value != 1
                return false
            end 
        end
        if result.empty?
            return false
        else
            return result
        end
    end

    def if_quit(arr)
        if arr.include?("quit")
            exit!
        end
    end

    def found_command(val)
        if @all_sql_cmd.include?(val.upcase)
            return true
        else
            return false
        end
    end
    
    def is_param_not_cmd(val)
        if val == nil or found_command(val)
            return false
        end
        return true
    end

    def read_cli (request)
        _print_time
        begin
            while buf = Readline.readline("> ", true)
                arr = buf.split
                if_quit(arr)
                request.reset
                initialize
                result = no_recur(arr)
                if result != false
                    if arr[0].upcase == "SELECT"
                        valid_select(result, arr, request)
                    elsif arr[0].upcase == "UPDATE"
                        valid_update(result, arr, request)
                    elsif arr[0].upcase == "INSERT"
                        valid_insert(result, arr, request)
                    elsif arr[0].upcase == "DELETE"
                        valid_delete(result, arr, request)
                    else
                        p "INVALID => Valid commands: SELECT, UPDATE, INSERT, DELETE"    
                    end
                else
                    p "INVALID => Query Commands are repeating OR Query command has spelling error OR query is empty"
                end
            end
          rescue Interrupt
            puts "\nExiting..."
          end
        
    end

    def _print_time
        get_time = Time.new
        puts "MySQLite version 0.1 #{get_time.year}-#{get_time.month}-#{get_time.day}"
    end
end 
