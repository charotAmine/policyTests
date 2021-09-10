describe 'Deploy a public storage' {
    it 'Not be deployed' {
        write-output "Starting test : "
        terraform -chdir="$($PSScriptRoot)/terraformFiles/" apply
        terraform init
        terraform plan
        $output = terraform apply -auto-approve 
        write-output "MY OUTPUT : $output"
        $policyName = "articlePost_P5A"
        "$output" -like "*$policyName*" | Should -Be $true
    }
}