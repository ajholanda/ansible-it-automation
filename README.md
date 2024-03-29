# Ansible - exemplos para automação de TI

Este repositório contém material para aprendizagem do [Ansible](https://www.ansible.com/).
O [Vagrant](https://www.vagrantup.com/) é usado para criar os ambientes de controle e controlados.

## Ambiente de execução

Para criar o ambiente de execução devemos:

- Instalar o [Virtual Box](https://www.virtualbox.org/);
- Instalar o [Vagrant](https://www.vagrantup.com/);
- Executar o Vagrant dentro do diretório contendo os exemplos:

```
vagrant up
```

- Conectar no *host* controlador (senha=vagrant):
```
vagrant ssh ansible
```
- Entrar no diretório com os exemplos:
```
cd ansible/
```
- Executar o *script* sem argumentos para mostrar as opções:
```
bash ./cmds.sh
```

Se quiser testar também para *hosts* com sistema Windows, descomente
a linha com as configurações da máquina virtual com o sistema Windows
no arquivo [Vagrantfile](Vagrantfile) e execute:
```
bash ./cmds.sh c11       # capitulo 11
```

Avisos:
- O arquivo com a máquina virtual do Windows é muito grande e seu
*download* e alguns comandos do Vagrant podem demorar muito dependendo
da configuração de rede e do computador em que as máquinas virtuais estão
sendo executadas.
- Os ambientes do Vagrant foram testados. Porém, problemas
com as máquinas virtuais durante o carregamento (`vagrant up`)
ainda podem ocorrer. A maior parte dos problemas é bem relatada em páginas de
grupos de discussão. Em último caso, a reconstrução das máquinas 
virtuais pode solucionar a maior parte dos problemas:

```
vagrant halt
vagrant destroy
vagrant up
```

## Contributions

Any contribution is welcome by opening an [issue](https://github.com/ajholanda/ansible-automacao-ti/issues) or sending a [pull request](https://github.com/ajholanda/ansible-automacao-ti/pulls).
