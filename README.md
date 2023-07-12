# QEMU Hook
This is a simple script that allows for the installation of a hook in QEMU for the `start` and `stopped` events

The configuration file can be modified at any time. An example of what it looks like is shown below:

```json
{
  "vm1": {
    "start": [
      ["/opt/vm1/start.sh"],
    ],
    "stopped": [
      ["/opt/vm1/stop.sh"],
    ]
  }
}
```

In the above example, `vm1` is the VM domain name. You can find the correct name for your VM by using the following command:

```sh
virsh list --all --name
```

The command array can contain multiple commands, and they are an array of arguments itself. Here is an example:
```json
    "stopped": [
      ["/opt/vm1/stop.sh"],
      ["/opt/common/clean.sh", "vm1"]
    ]
```

# Installation


```sh
cp config.json.example config.json
```
You can modify the `config.json` file now or later, since it will be read on each event

To install, run the following script. It will prompt you for the absolute path to the `config.json` file:

```sh
./install.sh
```

You will most likely need to restart libvirtd when finished
