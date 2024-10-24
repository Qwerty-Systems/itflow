<div class="modal" id="editAssetInterfaceModal<?php echo $interface_id; ?>" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content bg-dark">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fa fa-fw fa-ethernet mr-2"></i>Editing: <?php echo $interface_name; ?></h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>

            <form action="post.php" method="post" autocomplete="off">
                <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token'] ?>">
                <input type="hidden" name="interface_id" value="<?php echo $interface_id; ?>">

                <div class="modal-body bg-white" <?php if (lookupUserPermission('module_support') <= 1) { echo 'inert'; } ?>>

                    <div class="form-group">
                        <label>Interface Name</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fa fa-fw fa-ethernet"></i></span>
                            </div>
                            <input type="text" class="form-control" name="name" placeholder="Interface Name" value="<?php echo $interface_name; ?>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>MAC Address</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fa fa-fw fa-ethernet"></i></span>
                            </div>
                            <input type="text" class="form-control" name="mac" placeholder="MAC Address" value="<?php echo $interface_mac; ?>" data-inputmask="'alias': 'mac'" data-mask>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>IP</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fa fa-fw fa-ethernet"></i></span>
                            </div>
                            <input type="text" class="form-control" name="ip" placeholder="IP Address" value="<?php echo $interface_ip; ?>" data-inputmask="'alias': 'ip'" data-mask>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>IPv6</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fa fa-fw fa-ethernet"></i></span>
                            </div>
                            <input type="text" class="form-control" name="ipv6" placeholder="IPv6 Address" value="<?php echo $interface_ipv6; ?>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Port</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fa fa-fw fa-ethernet"></i></span>
                            </div>
                            <input type="text" class="form-control" name="port" placeholder="Interface Port ex. eth0" value="<?php echo $interface_port; ?>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Connected to</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fa fa-fw fa-network-wired"></i></span>
                            </div>
                            <select class="form-control select2" name="network">
                                <option value="">- None -</option>
                                <?php

                                $sql_network_select = mysqli_query($mysqli, "SELECT * FROM networks WHERE network_archived_at IS NULL AND network_client_id = $client_id ORDER BY network_name ASC");
                                while ($row = mysqli_fetch_array($sql_network_select)) {
                                    $network_id_select = $row['network_id'];
                                    $network_name_select = nullable_htmlentities($row['network_name']);
                                    $network_select = nullable_htmlentities($row['network']);

                                    ?>
                                    <option <?php if ($network_id == $network_id_select) { echo "selected"; } ?> value="<?php echo $network_id_select; ?>"><?php echo $network_name_select; ?> - <?php echo $network_select; ?></option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <textarea class="form-control" rows="5" placeholder="Enter some notes" name="notes"><?php echo $interface_notes; ?></textarea>
                    </div>

                </div>
                <div class="modal-footer bg-white">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" name="edit_asset_interface" class="btn btn-primary"><i class="fa fa-check mr-2"></i>Save</button>
                </div>
            </form>
        </div>
    </div>
</div>
