inputs: final: prev: let
  fromYAML = yaml: builtins.fromJSON (
    builtins.readFile (
      final.runCommand "from-yaml"
        {
          inherit yaml;
          allowSubstitutes = false;
          preferLocalBuild = true;
        }
        ''
          ${final.remarshal}/bin/remarshal  \
            -if yaml \
            -i <(echo "$yaml") \
            -of json \
            -o $out
        ''
    )
  );

  readYAML = path: fromYAML (builtins.readFile path);
in
{
  lib = prev.lib // {
    inherit fromYAML readYAML;
  };
}
