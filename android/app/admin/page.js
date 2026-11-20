'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/utils/supabase/client'

export default function AdminDashboard() {
  const router = useRouter()
  const [checking, setChecking] = useState(true)

  useEffect(() => {
    let active = true

    async function verifyAdmin() {
      const supabase = createClient()

      const { data: { user }, error: authError } =
        await supabase.auth.getUser()

      if (!active) return

      if (authError || !user) {
        router.replace('/')
        return
      }

      const { data, error } = await supabase.rpc('is_admin')

      if (!active) return

      if (error || data !== true) {
        router.replace('/')
        return
      }

      setChecking(false)
    }

    verifyAdmin()

    return () => {
      active = false
    }
  }, [router])

  if (checking) {
    return <div dir="rtl">جارٍ التحقق من صلاحيات المدير...</div>
  }

  return (
    <div dir="rtl">
      <h1>لوحة إدارة مهنتي</h1>
      <p>مرحباً بك في لوحة الإدارة</p>
    </div>
  )
}
