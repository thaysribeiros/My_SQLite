require_relative 'main'


def test_cases()
    request = MySqliteRequest.new # create MySqliteRequest obj
    
    #============================
    #           TEST 1
    #============================

    # request.from($nba_players_data_table)
    # request.select('name')
    # request.run

    # ADDITIONAL TEST

    # request.from($nba_players_data_table) #'./csv_files/nba_player_data.csv'
    # request.select('name')
    # request.where('birth_state', 'Indiana')
    # request.run # SELECT needs to print

    # PASSED

    #============================
    #           TEST 2
    #============================

    # request.from($nba_players_data_table)
    # request.select('name')
    # request.where('college', 'University of California')
    # request.run # SELECT needs to print
    
    # PASSED

    #============================
    #           TEST 3
    #============================

    # request.from($nba_players_data_table)
    # request.select('name')
    # request.where('college', 'University of California')
    # request.where('year_start', '1997')
    # request.run

    # PASSED

    #============================
    #           TEST 4
    #============================
    
    # request.insert($nba_players_data_table)
    # request.values('name' => 'Alaa Abdelnaby', 'year_start' => '1991', 'year_end' => '1995', 'position' => 'F-C', 'height' => '6-10', 'weight' => '240', 'birth_date' => "\"June 24, 1968\"", 'college' => 'Duke University')
    # request.run

    # PASSED

    #============================
    #           TEST 5
    #============================
    
    # request.update($nba_players_data_table)
    # request.set('name' => 'Alaa Renamed')
    # request.where('name', 'Alaa Abdelnaby')
    # request.run

    # PASSED

    #============================
    #           TEST 6
    #============================
    
    # request.delete()
    # request.from($nba_players_data_table)
    # request.where('name', 'Matt Zunic')
    # request.run

    # PASSED

    #============================
    #         START CLI
    #============================
    
    # req_cli = SqliteCli.new
    # req_cli.read_cli(request)

    # PASSED

    #============================
    #        TEST 7 CLI
    #============================
    
    # CLI: SELECT * FROM ./csv_files/students.csv

    # PASSED

    #============================
    #        TEST 8 CLI
    #============================
    # Without space ========> FIX BUG
    
    # SELECT name,email FROM ./csv_files/students.csv WHERE name = 'Mila'
    
    # With space
    
    # SELECT name, email FROM ./csv_files/students.csv WHERE name = 'Mila'

    # PASSED

    #============================
    #        TEST 9 CLI
    #============================

    # Without space ========> FIX BUG

    # INSERT INTO ./csv_files/students.csv VALUES (John,john@johndoe.com,A,https://blog.johndoe.com)

    # With space

    # CLI: INSERT INTO ./csv_files/students.csv VALUES (John, john@johndoe.com, A, https://blog.johndoe.com)

    # PASSED

    #============================
    #        TEST 10 CLI
    #============================

    # CLI: UPDATE ./csv_files/students.csv SET email = 'jane@janedoe.com', blog = 'https://blog.janedoe.com' WHERE name = 'Mila'

    # PASSED

    #============================
    #        TEST 11 CLI
    #============================

    # CLI: DELETE FROM ./csv_files/students.csv WHERE name = 'John'
    
    # PASSED

    #============================
    #        TEST 12 CLI
    #============================

    # CLI: SELECT name FROM ./csv_files/nba_player_data.csv WHERE birth_date = 'June 24, 1968'
    
    # COMMENT: Make sure to add quotes in birth_date value in ./csv_files/nba_player_data.csv

    # PASSED
end

test_cases()
