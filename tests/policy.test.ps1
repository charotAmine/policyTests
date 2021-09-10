describe 'Deploy a public storage' {
    it 'Not be deployed' {
        terraform -chdir="$($PSScriptRoot)/terraformFiles/" apply
        terraform init
        terraform plan
        $output = terraform apply -auto-approve 
        
        $policyName = "articlePost_PA"
        "$output" -like "*$policyName*" | Should -Be $true
    }
}