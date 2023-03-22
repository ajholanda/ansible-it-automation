#!/usr/bin/env bash

function ECHO {
    >&2 echo "INFO [$1]"
}

function RUN {
    echo $1
    eval $1 && test 1 -eq 1
    sleep 2
}

function exec_adhoc_cmds() {
    ECHO "Executa o ping no host controlado w3.example.net"
    RUN "ansible w3.example.net -i hosts.ini -m ping"

    ECHO "Instala o pacote apache2 usando o módulo package"
    RUN 'ansible web.example.net -i hosts.ini -m package -a "name=apache2 state=present" --become'

    ECHO "Remove o pacote apache2 nos hosts do grupo webservers"
    RUN 'ansible webservers -i hosts.ini -m package -a "name=apache2 state=absent" --become'

    # TODO: find and evaluate this command in the manuscript
    ECHO "Instala o pacote httpd usando o módulo dnf, ok nas distribuições derivadas da RedHat"
    RUN 'ansible w3.example.net -i hosts.ini -m dnf -a name=httpd --become'

    ECHO "Instalação do pacote apache2 sem a inclusão explícita do arquivo de inventário"
    RUN 'ansible web.example.net -m package -a name=apache2'

    ECHO "Lista de parâmetros do arquivo de configuração do ansible"
    RUN "ansible-config list | cat"

    ECHO "Instala o programa git nos hosts do grupo lab:"
    RUN 'ansible lab -m package -a name=git'

    ECHO "Copia o arquivo /etc/resolv.conf do controlador para os hosts pertencentes ao grupo lab:"
    RUN 'ansible lab -m copy -a "src=/etc/resolv.conf dest=/etc/"'

    ECHO "Pega o arquivo /var/log/apache2/access.log de web.example.net"
    RUN 'ansible web.example.net -m fetch -a "src=/var/log/apache2/access.log dest=/tmp/"'

    ECHO "Copia o arquivo /etc/passwd do hosts do grupo lab para o controlador"
    RUN 'ansible lab -m fetch -a "src=/etc/passwd dest=/tmp/"'

    ECHO "Executa o comando stat no arquivo w3.example.net:/etc/passwd"
    RUN "ansible w3.example.net -m stat -a \"path=/etc/passwd\""

    ECHO "Cria o diretório /home/nfs, se não existir, nos hosts do grupo lab:"
    RUN 'ansible lab -m file -a "path=/home/nfs state=directory"'

    ECHO "Altera as permissões do arquivo /etc/shadow nos hosts so grupo lab"
    RUN 'ansible lab -m file -a "path=/etc/shadow owner=root group=shadow mode=0640"'

    ECHO "Remove o arquivo /tmp/texput.log de todos os hosts"
    RUN 'ansible all -m file -a "path=/tmp/texput.log state=absent"'

    ECHO "Lista usauário que autenticaram em todos os hosts"
    RUN 'ansible all -m shell -a last'
}

function exec_playbook_cmds() {
    ECHO "Executa o playbook webserver.yml"
    RUN 'ansible-playbook webserver.yml'

    ECHO "Executa o playbook webserver-Debian.yml"
    RUN 'ansible-playbook webserver-Debian.yml'

    ECHO "Executa o playbook webserver-distro.yml"
    RUN 'ansible-playbook webserver-distro.yml'
}

function exec_vars_cmds() {
    ECHO "Lista as variáveis mágicas do sistema no host web.exemplo"
    RUN 'ansible -m setup web.exemplo'

    ECHO "Executa o playbook webserver-vars.yml"
    RUN 'ansible-playbook webserver-vars.yml'

    ECHO "Executa o playbook webserver-host_vars.yml"
    RUN 'ansible-playbook webserver-host_vars.yml'
}

function exec_roles_cmds() {
    ECHO "Executa o playbook webserver-role.yml (role webserver) somente em web.example.net"
    RUN 'ansible-playbook webserver-role.yml --limit web.example.net'
}

function exec_template_cmds() {
    ECHO "* Filtros"
    RUN "ansible-playbook filters.yml"
}

function exec_crypto_cmds() {
    ECHO "Executa o role rsyncserver usando o --vault-id"
    RUN "ansible-playbook --vault-id vault.txt rsyncservers.yml"

    ECHO "Criptografa um arquivo usando o vault ID prod"
    RUN "ansible-vault encrypt --vault-id prod@vault-prod.txt sssd/templates/sssd.conf.j2 --encrypt-vault-id prod 2>/dev/null"
}

function exec_linux_cmds() {
    exec_adhoc_cmds
    exec_playbook_cmds
    exec_vars_cmds
    exec_roles_cmds
    exec_template_cmds
    exec_crypto_cmds
}

function exec_windows_cmds() {
    2>& echo "INFO: Not implemented yet!"
}

USAGE=$(cat <<-EOM
$0 [--all | -c2 | -c3 | -c4 | -c6 | --linux | --windows]
onde cada opção executa os comandos:
  --all     todos
  -c2       do Capítulo 2 - comandos ad-hoc
  -c3       do Capítulo 3 - playbook
  -c4       do Capítulo 4 - variáveis
  -c5       do Capítulo 5 - roles
  -c6       do Capítulo 6 - gabarito
  -c7       do Capítulo 7 - criptografia
  --linux   para os sistemas Linux
  --windows para os sistemas Windows
EOM
)

case $1 in
    "--all")
        exec_linux_cmds
        ;;
    "-c2")
        exec_adhoc_cmds
        ;;
    "-c3")
        exec_playbook_cmds
        ;;
    "-c4")
        exec_vars_cmds
        ;;
    "-c5")
        exec_roles_cmds
        ;;
    "-c6")
        exec_template_cmds
        ;;
    "-c7")
        exec_crypto_cmds
        ;;
    "--linux")
        exec_linux_cmds
        ;;
    "--windows")
        exec_windows_cmds
        ;;
    *)
        >&2 echo "$USAGE"
        exit 1
        ;;
esac

ECHO "DONE"
exit 0