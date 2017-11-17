function GetTypes($id, $name)
{
    $ht = new-object System.Collections.Hashtable;

    $con = New-Object -TypeName System.Data.SqlClient.SqlConnection($global:powerStreamConnectionString);        
    $con.Open();

    try
    {
        #create the MigrationRunInstance table...
        $sql = $con.CreateCommand()
        $sql.CommandText = "select * from MVPType where isactive = 1"           
        $reader = $sql.ExecuteReader();     

        while($reader.read())
        {        
            $id = $reader["mvptype"]
            $name = $reader["shortname"]

            $ht.add($id, $name);
        }
    }
    catch
    {
    }

    $reader.close();
    $con.close();

    return $ht;
}

function ExportIds($id, $name)
{
    $con = New-Object -TypeName System.Data.SqlClient.SqlConnection($global:powerStreamConnectionString);        
    $con.Open();

    try
    {
        #create the MigrationRunInstance table...
        $sql = $con.CreateCommand()
        $sql.CommandText = "select * from MVP where mvptype = $id" 
        $reader = $sql.ExecuteReader();     

        while($reader.read())
        {        
            $twitter = $reader["twitter"]  
            
            if ($twitter -and $twitter.tostring().Length -gt 0)
            {          
                add-content "$name-ids.txt" $twitter;
            }
        }
    }
    catch
    {
    }

    $reader.close();
    $con.close();
}

cd "C:\Users\givenscj\OneDrive\My Scripts\MVP";

$global:powerStreamConnectionString = "server=svr-jc-db1;database=mvptracking;uid=sa;pwd=Seattle123";

$types = getTypes;

foreach($id in $types.keys)
{
    $name = $types[$id];
    remove-item "$name-ids.txt" -ea SilentlyContinue;
    ExportIds $id $name;
}