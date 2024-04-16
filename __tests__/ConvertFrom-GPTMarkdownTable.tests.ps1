Import-Module "$PSScriptRoot\..\PowerShellAIAssistant.psd1" -Force

Describe "ConvertFrom-GPTMarkdownTable" -Tag GPTMarkdownTable {
    It "ConvertFrom-GPTMarkdownTable" {
        $markdown = @"
| p1 | p2 | p3 |
| --- | --- | --- |
| 1 | 2 | 3 |
| 4 | 5 | 6 |
"@
        $actual = ConvertFrom-GPTMarkdownTable $markdown.Trim()
        
        $actual | Should -Not -BeNullOrEmpty

        $actual.Count | Should -Be 2
        $names = $actual[0].psobject.Properties.Name

        $names.Count | Should -Be 3
        $names[0] | Should -Be 'p1'
        $names[1] | Should -Be 'p2'
        $names[2] | Should -Be 'p3'


        $actual[0].'p1' | Should -Be 1
        $actual[0].'p2' | Should -Be 2
        $actual[0].'p3' | Should -Be 3

        $actual[1].'p1' | Should -Be 4
        $actual[1].'p2' | Should -Be 5
        $actual[1].'p3' | Should -Be 6

    }

    It "ConvertFrom-GPTMarkdownTable - no | at start or end" {
        $markdown = @"
Vegetable | Calories | Protein (g) | Carbs (g) | Fat (g)

Carrot | 41 | 1 | 9 | 0
Broccoli | 34 | 2 | 6 | 0
Cucumber | 16 | 1 | 4 | 0
Spinach | 7 | 1 | 1 | 0
Kale | 33 | 2 | 6 | 0
Celery | 16 | 0 | 3 | 0
"@

        $actual = ConvertFrom-GPTMarkdownTable $markdown

        $actual | Should -Not -BeNullOrEmpty
        $actual.Count | Should -Be 6

        $names = $actual[0].psobject.Properties.Name

        $names.Count | Should -Be 5
        $names[0] | Should -Be 'Vegetable'
        $names[1] | Should -Be 'Calories'
        $names[2] | Should -Be 'Protein (g)'
        $names[3] | Should -Be 'Carbs (g)'
        $names[4] | Should -Be 'Fat (g)'

        $actual[0].'Vegetable' | Should -Be 'Carrot'
        $actual[0].'Calories' | Should -Be 41
        $actual[0].'Protein (g)' | Should -Be 1
        $actual[0].'Carbs (g)' | Should -Be 9
        $actual[0].'Fat (g)' | Should -Be 0

        $actual[-1].'Vegetable' | Should -Be 'Celery'
        $actual[-1].'Calories' | Should -Be 16
        $actual[-1].'Protein (g)' | Should -Be 0
        $actual[-1].'Carbs (g)' | Should -Be 3
        $actual[-1].'Fat (g)' | Should -Be 0
    }

    It "ConvertFrom-GPTMarkdownTable - one for the road" {
        $markdown = @"
| President | Term | Vice President |
|-----------|------|---------------|
| George Washington | 1789-1797 | John Adams |
| John Adams | 1797-1801 | Thomas Jefferson |
| Thomas Jefferson | 1801-1809 | Aaron Burr, George Clinton |
| James Madison | 1809-1817 | George Clinton, Elbridge Gerry |
| James Monroe | 1817-1825 | Daniel D. Tompkins |        
"@

        $actual = ConvertFrom-GPTMarkdownTable $markdown

        $actual | Should -Not -BeNullOrEmpty
        $actual.Count | Should -Be 5

        $names = $actual[0].psobject.Properties.Name

        $names.Count | Should -Be 3
        $names[0] | Should -Be 'President'
        $names[1] | Should -Be 'Term'
        $names[2] | Should -Be 'Vice President'

        $actual[0].'President' | Should -Be 'George Washington'
        $actual[0].'Term' | Should -Be '1789-1797'
        $actual[0].'Vice President' | Should -Be 'John Adams'

        $actual[-1].'President' | Should -Be 'James Monroe'
        $actual[-1].'Term' | Should -Be '1817-1825'
        $actual[-1].'Vice President' | Should -Be 'Daniel D. Tompkins'
    }

    It "ConvertFrom-GPTMarkdownTable - with whitespace" {
        $markdown = @"


        | Column 1 | Column 2 | Column 3 |
        | -------- | -------- | -------- |
        | Cell 1   | Cell 2   | Cell 3   |
        | Cell 4   | Cell 5   | Cell 6   |
        | Cell 7   | Cell 8   | Cell 9   |
"@
        $actual = ConvertFrom-GPTMarkdownTable $markdown

        $actual | Should -Not -BeNullOrEmpty
        $actual.Count | Should -Be 3

        $names = $actual[0].psobject.Properties.Name
        $names.Count | Should -Be 3
        $names[0] | Should -Be 'Column 1'
        $names[1] | Should -Be 'Column 2'
        $names[2] | Should -Be 'Column 3'

        $actual[0].'Column 1' | Should -Be 'Cell 1  '
        $actual[0].'Column 2' | Should -Be 'Cell 2  '
        $actual[0].'Column 3' | Should -Be 'Cell 3  '

        $actual[-1].'Column 1' | Should -Be 'Cell 7  '
        $actual[-1].'Column 2' | Should -Be 'Cell 8  '
        $actual[-1].'Column 3' | Should -Be 'Cell 9  '
    }
}