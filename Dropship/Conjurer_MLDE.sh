#!/usr/bin/env bash

set -e 
local_home=${local_home:-"/run/determined/workdir"}
julia_version=${julia_version:-"1.9.2"}
apt install -y vim screen htop git

cd ${local_home}
git clone https://github.com/owainkenwayucl/JuliaML.git

cd JuliaML
wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-${julia_version}-linux-x86_64.tar.gz

tar zxvf julia-${julia_version}-linux-x86_64.tar.gz
ln -s julia-${julia_version} julia

export PATH=${local_home}/JuliaML/julia/bin:${PATH}

julia -e "using Pkg; Pkg.add(\"IJulia\")"
cat ../environment.sh << EOF
#!/usr/bin/env bash
export PATH=${local_home}/JuliaML/julia/bin:${PATH}
EOF

chmod +x ../environment.sh

cd Fashion
source ./setup.sh
