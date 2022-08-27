#
module "network" {
    source = "./modules/network"
    tags    = var.tags
    vpc_name   =   var.vpc_name
    vpc_cidr    =   var.vpc_cidr
    priv_subnet =   var.priv_subnet
    pub_subnet  =   var.pub_subnet
    location    = var.location
    environmnet     = var.environment
    sg_rules    =   var.sg_rules
    
    }

#
module "compute" {
    source = "./modules/compute"
    tags    = var.tags
    location    = var.location
    count_debian_vm  = var.count_debian_vm
    priv_subnet_id  = module.network.priv_subnet_id
    pub_subnet_id   = module.network.pub_subnet_id
    
}