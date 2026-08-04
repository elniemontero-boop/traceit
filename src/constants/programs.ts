export interface DegreeProgramOption {
  value: string
  label: string
  acronym: string
  department: string
}

export const DEGREE_PROGRAMS: DegreeProgramOption[] = [
  {
    value: 'Bachelor of Science in Information Technology',
    label: 'Bachelor of Science in Information Technology (BSIT)',
    acronym: 'BSIT',
    department: 'Information Technology',
  },
  {
    value: 'Bachelor of Secondary Education major in English',
    label: 'Bachelor of Secondary Education major in English (BSED-Eng)',
    acronym: 'BSED-Eng',
    department: 'Secondary Education',
  },
  {
    value: 'Bachelor of Secondary Education major in Filipino',
    label: 'Bachelor of Secondary Education major in Filipino (BSED-Fil)',
    acronym: 'BSED-Fil',
    department: 'Secondary Education',
  },
  {
    value: 'Bachelor of Secondary Education major in Mathematics',
    label: 'Bachelor of Secondary Education major in Mathematics (BSED-Math)',
    acronym: 'BSED-Math',
    department: 'Secondary Education',
  },
  {
    value: 'Bachelor of Elementary Education',
    label: 'Bachelor of Elementary Education (BEED)',
    acronym: 'BEED',
    department: 'Elementary Education',
  },
  {
    value: 'Bachelor of Science in Business Administration',
    label: 'Bachelor of Science in Business Administration (BSBA)',
    acronym: 'BSBA',
    department: 'Business Administration',
  },
  {
    value: 'Doctor of Philosophy',
    label: 'Doctor of Philosophy (PhD)',
    acronym: 'PhD',
    department: 'Graduate Studies',
  },
]
